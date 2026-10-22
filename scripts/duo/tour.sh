#!/usr/bin/env bash
# Runs the screens tour on the iPhone Duo simulator and screenshots every screen in each of
# the device's poses: closed, open, partially open like a book, partially open on its side
# like a laptop (tabletop), and open upright (DEC-3).
#
#     scripts/duo/tour.sh <simulator udid> <output folder> [here | record <shots>]
#
# Needs Xcode 27.1's Device Hub open on the device (it has the only pose controls), the
# Mac unlocked (Device Hub has no window while it is locked) and Accessibility permission
# for the terminal. The device starts and ends closed. With `here`, the device stays in
# the pose it is in and both displays are captured, the one not in use black. With
# `record` and a comma-separated list of shot names (`player,pdf`), those screens are also
# recorded through every pose, the outer and inner displays side by side in one video.
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

# Starts recording [display] to [file]; prints the recorder's pid.
start_recording() {
  xcrun simctl io "$udid" recordVideo --force --codec=h264 --display="$1" "$2" \
    > /dev/null 2>&1 &
  echo $!
}

stop_recording() {
  kill -INT "$1" 2> /dev/null || true
  wait "$1" 2> /dev/null || true
}

# [poses] while recording: the outer display while closed, then the inner one from the
# moment it opens (simctl cannot record a display that is off), joined into one video.
recorded() {
  local shot=$1
  local outer inner
  outer=$(start_recording primary "$out/${shot}__a.mov")
  sleep 2
  capture "${shot}__1_closed" primary
  build/duo_pose Open || true
  sleep 1
  inner=$(start_recording primary-1 "$out/${shot}__b.mov")
  stop_recording "$outer"
  sleep 3
  capture "${shot}__2_open" primary-1
  pose "Partially Open"
  capture "${shot}__3_book" primary-1
  pose "Rotate Right"
  capture "${shot}__4_tabletop" primary-1
  pose Open
  capture "${shot}__5_open_tall" primary-1
  stop_recording "$inner"
  close_upright
  ffmpeg -loglevel error -y -i "$out/${shot}__a.mov" -i "$out/${shot}__b.mov" \
    -filter_complex "[0]scale=-2:1080,pad=1600:1080:(ow-iw)/2:0:white,setsar=1[a];[1]scale=1600:1080:force_original_aspect_ratio=decrease,pad=1600:1080:(ow-iw)/2:(oh-ih)/2:white,setsar=1[b];[a][b]concat=n=2:v=1[v]" \
    -map "[v]" -c:v libx264 -pix_fmt yuv420p -crf 26 "$out/${shot}.mp4" &&
    rm "$out/${shot}__a.mov" "$out/${shot}__b.mov" ||
    echo "   could not join the recordings of $shot"
}

# Closes the device and turns it until the outer display is upright. A quarter turn
# pressed while Device Hub animates can be lost, so the turns are checked, not counted.
close_upright() {
  pose Closed
  local check="$sync_dir/check.png" width height
  for _ in 1 2 3 4; do
    xcrun simctl io "$udid" screenshot --display=primary "$check" > /dev/null 2>&1
    width=$(sips -g pixelWidth "$check" | awk '/pixelWidth/ {print $2}')
    height=$(sips -g pixelHeight "$check" | awk '/pixelHeight/ {print $2}')
    [ "$width" -lt "$height" ] && return
    pose "Rotate Right"
  done
}

poses() {
  local shot=$1
  if [ "$mode" = here ]; then
    capture "${shot}__outer" primary
    capture "${shot}__inner" primary-1
    return
  fi
  capture "${shot}__1_closed" primary
  pose Open
  capture "${shot}__2_open" primary-1
  pose "Partially Open"
  capture "${shot}__3_book" primary-1
  pose "Rotate Right"
  capture "${shot}__4_tabletop" primary-1
  pose Open
  capture "${shot}__5_open_tall" primary-1
  close_upright
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
    if [ "$mode" = record ] && printf ',%s,' "$record" | grep -q ",${shot#*_},"; then
      recorded "$shot"
    else
      poses "$shot"
    fi
    touch "$sync_dir/$shot.done"
    seen=$((seen + 1))
  fi
  sleep 1
done
wait "$tour" && echo "== tour passed" || { echo "== tour failed; see $log"; exit 1; }
