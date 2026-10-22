#!/usr/bin/env bash
# Runs the screens tour on the iPhone Duo simulator and screenshots every screen in each of
# the device's poses: closed, open, partially open like a book, partially open on its side
# like a laptop (tabletop), and open upright (DEC-3).
#
#     scripts/duo/tour.sh <simulator udid> <output folder> [here]
#
# Needs Xcode 27.1's Device Hub open on the device (it has the only pose controls), the
# Mac unlocked (Device Hub has no window while it is locked) and Accessibility permission
# for the terminal. The device starts and ends closed. With `here`, the device stays in
# the pose it is in and both displays are captured, the one not in use black.
set -euo pipefail
cd "$(dirname "$0")/../.."
. scripts/toolchain.sh

udid=$1
out=$2
here=${3:-}
mkdir -p "$out" build
swiftc -O scripts/duo/duo_pose.swift -o build/duo_pose
sync_dir=$(mktemp -d)
log="$out/tour.log"
trap 'rm -rf "$sync_dir"' EXIT

pose() { build/duo_pose "$1" || echo "   could not press $1"; sleep 4; }
# The outer display is "primary" and the inner one "primary-1".
capture() { xcrun simctl io "$udid" screenshot --display="$2" "$out/${1}.png" > /dev/null 2>&1 || echo "   no screenshot of $1"; }

poses() {
  local shot=$1
  if [ "$here" = here ]; then
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
  # Three more quarter turns bring the device back to where it started.
  pose "Rotate Right"
  pose "Rotate Right"
  pose "Rotate Right"
  pose Closed
}

[ "$here" = here ] || pose Closed
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
    poses "$shot"
    touch "$sync_dir/$shot.done"
    seen=$((seen + 1))
  fi
  sleep 1
done
wait "$tour" && echo "== tour passed" || { echo "== tour failed; see $log"; exit 1; }
