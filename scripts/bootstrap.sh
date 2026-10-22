#!/usr/bin/env bash
# One-time setup for a fresh checkout: checks the toolchain, resolves dependencies and runs
# code generation. Safe to rerun.
set -euo pipefail
cd "$(dirname "$0")/.."

expected_flutter=$(python3 -c "import json;print(json.load(open('.fvmrc'))['flutter'])")

echo "== toolchain"
if command -v fvm >/dev/null; then
  fvm install "$expected_flutter" --skip-pub-get > /dev/null
  fvm use "$expected_flutter" --skip-pub-get --force > /dev/null
fi
. scripts/toolchain.sh
command -v flutter >/dev/null || { echo "flutter not found" >&2; exit 1; }
actual_flutter=$(flutter --version --machine 2>/dev/null | python3 -c "import json,sys;print(json.load(sys.stdin)['frameworkVersion'])")
if [ "$actual_flutter" != "$expected_flutter" ]; then
  echo "Flutter $actual_flutter is active; this repository pins $expected_flutter (.fvmrc). Install fvm or switch releases." >&2
  exit 1
fi
flutter --version | sed -n 1p

echo "== dependencies"
flutter pub get

echo "== code generation"
./scripts/codegen.sh

echo "== bootstrap complete"
