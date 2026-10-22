# Sourced by the other scripts. Puts the Flutter SDK that .fvmrc pins first on PATH when fvm
# has linked it (`fvm install` or `fvm use` in the repository creates .fvm/flutter_sdk), so a
# machine whose global Flutter is a different release still builds with the pinned one.
if [ -x .fvm/flutter_sdk/bin/flutter ]; then
  PATH="$PWD/.fvm/flutter_sdk/bin:$PATH"
  export PATH
fi
