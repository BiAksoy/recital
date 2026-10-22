#!/usr/bin/env bash
# What "shippable" means here: the code analyzes clean, every hand-written Dart file is
# formatted, the decision and question indexes are current, and the tests pass. Run it
# before every commit.
set -euo pipefail
cd "$(dirname "$0")/.."
. scripts/toolchain.sh

echo "== analyze"
dart analyze --fatal-infos

echo "== format"
find lib test -name '*.dart' -not -path '*/l10n/generated/*' \
  -not -name '*.g.dart' -not -name '*.mapper.dart' -not -name '*.gr.dart' -print0 |
  xargs -0 dart format --output=none --set-exit-if-changed

echo "== decision and question records"
python3 scripts/work_records.py check

echo "== test"
flutter test

echo "== gate passed"
