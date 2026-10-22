#!/usr/bin/env bash
# Runs the screens tour on the iPhone Duo simulator and screenshots every screen in each of
# the device's poses: closed, open, partially open like a book, partially open on its side
# like a laptop (tabletop), and open upright (DEC-3).
#
#     scripts/duo/tour.sh <simulator udid> <output folder> [here | record[-only] <shots>]
#
# Needs Xcode 27.1's Device Hub open on the device (it has the only pose controls), the
# Mac unlocked (Device Hub has no window while it is locked) and Accessibility permission
# for the terminal. The device starts and ends closed. With `here`, the device stays in
# the pose it is in and both displays are captured, the one not in use black. With
# `record` and a comma-separated list of shot names (`player,pdf`), those screens are also
# filmed through every pose, from closed to open and back; `record-only` films those and
# skips the screenshots of the rest.
set -euo pipefail
cd "$(dirname "$0")/../.."
. scripts/toolchain.sh

udid=$1
out=$2
mode=${3:-}
record=${4:-}
mkdir -p "$out" build
swiftc -O scripts/duo/duo_pose.swift -o build/duo_pose
sync_dir=$(mktemp -d)
log="$out/tour.log"
trap 'rm -rf "$sync_dir"' EXIT

# Device Hub has no window while the Mac is locked; a press waits for it to come back.
pose() {
  until build/duo_pose "$1"; do
    echo "   waiting to press $1 (is the Mac locked?)"
    sleep 30
  done
  sleep 4
}
# The outer display is "primary" and the inner one "primary-1".
capture() { xcrun simctl io "$udid" screenshot --display="$2" "$out/${1}.png" > /dev/null 2>&1 || echo "   no screenshot of $1"; }

# Screenshots whichever display "$frames/display" names, one after another, until
# "$frames/stop" appears. simctl's recordVideo keeps the inner display's native
# orientation and cannot record a display that is off, so the video is made of these.
filming() {
  local frames=$1 count=0
  while [ ! -f "$frames/stop" ]; do
    xcrun simctl io "$udid" screenshot --display="$(cat "$frames/display")" \
      "$frames/$(printf %05d "$count").png" > /dev/null 2>&1 && count=$((count + 1))
  done
}

# Prints "wide" or "tall" for a display, from a screenshot of it.
shape() {
  local check="$sync_dir/check.png" width height
  xcrun simctl io "$udid" screenshot --display="$1" "$check" > /dev/null 2>&1
  width=$(sips -g pixelWidth "$check" | awk '/pixelWidth/ {print $2}')
  height=$(sips -g pixelHeight "$check" | awk '/pixelHeight/ {print $2}')
  if [ "$width" -gt "$height" ]; then echo wide; else echo tall; fi
}

# Turns the device until display $1 is $2 ("wide" or "tall"). A quarter turn pressed while
# Device Hub animates can be lost, so every pose checks its shape rather than counting
# turns.
turn_to() {
  for _ in 1 2 3 4; do
    [ "$(shape "$1")" = "$2" ] && return
    pose "Rotate Right"
  done
  echo "   could not turn $1 $2"
}

close_upright() {
  pose Closed
  turn_to primary tall
}

# The five poses, each checked and screenshotted; [between] runs after each press, so
# filming can follow the display in use.
cycle() {
  local shot=$1 between=${2:-true}
  capture "${shot}__1_closed" primary
  pose Open
  $between primary-1
  turn_to primary-1 wide
  capture "${shot}__2_open" primary-1
  pose "Partially Open"
  turn_to primary-1 wide
  capture "${shot}__3_book" primary-1
  pose "Rotate Right"
  turn_to primary-1 tall
  capture "${shot}__4_tabletop" primary-1
  pose Open
  turn_to primary-1 tall
  capture "${shot}__5_open_tall" primary-1
  pose Closed
  $between primary
  turn_to primary tall
}

# [cycle] filmed, the screenshots joined into "$out/<shot>.mp4" at the rate they were
# taken, each fitted to one frame size.
recorded() {
  local shot=$1
  local frames="$sync_dir/frames-$shot"
  mkdir -p "$frames"
  echo primary > "$frames/display"
  local started
  started=$(date +%s)
  filming "$frames" &
  local filmer=$!
  sleep 2
  follow() { echo "$1" > "$frames/display"; }
  cycle "$shot" follow
  sleep 2
  touch "$frames/stop"
  wait "$filmer"
  local count rate seconds
  seconds=$(($(date +%s) - started))
  count=$(find "$frames" -name '*.png' | wc -l | tr -d ' ')
  rate=$(awk -v n="$count" -v s="$seconds" 'BEGIN { printf "%.3f", n / (s > 0 ? s : 1) }')
  ffmpeg -loglevel error -y -framerate "$rate" -i "$frames/%05d.png" \
    -vf "scale=1600:1080:force_original_aspect_ratio=decrease,pad=1600:1080:(ow-iw)/2:(oh-ih)/2:white,setsar=1" \
    -c:v libx264 -pix_fmt yuv420p -r 30 -crf 24 "$out/${shot}.mp4" ||
    echo "   could not make the video of $shot"
  rm -rf "$frames"
}

poses() {
  local shot=$1
  if [ "$mode" = here ]; then
    capture "${shot}__outer" primary
    capture "${shot}__inner" primary-1
    return
  fi
  cycle "$shot"
}

[ "$mode" = here ] || close_upright
flutter test integration_test/screens_tour_test.dart -d "$udid" \
  --dart-define=DUO_TOUR_SYNC="$sync_dir" > "$log" 2>&1 &
tour=$!
seen=0
while kill -0 "$tour" 2> /dev/null; do
  shots=$(grep -o 'DUO_TOUR_SHOT [0-9a-z_]*' "$log" | awk '{print $2}' || true)
  count=$(printf '%s' "$shots" | grep -c . || true)
  if [ "$count" -gt "$seen" ]; then
    shot=$(printf '%s\n' "$shots" | sed -n "$((seen + 1))p")
    echo "== $shot"
    chosen=no
    printf ',%s,' "$record" | grep -q ",${shot#*_}," && chosen=yes
    if [ "$mode" = record ] && [ $chosen = yes ]; then
      recorded "$shot"
    elif [ "$mode" = record-only ]; then
      [ $chosen = yes ] && recorded "$shot"
    else
      poses "$shot"
    fi
    touch "$sync_dir/$shot.done"
    seen=$((seen + 1))
  fi
  sleep 1
done
wait "$tour" && echo "== tour passed" || { echo "== tour failed; see $log"; exit 1; }
