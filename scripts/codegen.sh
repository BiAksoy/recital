#!/usr/bin/env bash
# Regenerates the Dart code the tools own: the localizations from lib/l10n/app_en.arb, then
# build_runner (riverpod_generator, dart_mappable, auto_route).
set -euo pipefail
cd "$(dirname "$0")/.."
. scripts/toolchain.sh

echo "== gen-l10n"
flutter gen-l10n

echo "== build_runner"
dart run build_runner build
