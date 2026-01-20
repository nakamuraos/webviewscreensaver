#!/bin/bash
set -u

abort() {
  printf "%s\n" "$@"
  exit 1
}

if [ -z "${BASH_VERSION:-}" ]; then
  abort "Bash is required to interpret this script."
fi

if [[ "$(uname)" != "Darwin" ]]; then
  abort "WebViewScreenSaver is only supported on macOS."
fi

if ! command -v git >/dev/null; then
    abort "Install process requires Git."
fi

if ! command -v xcodebuild >/dev/null; then
    abort "Install process requires Xcode."
fi

DIR_NAME="webviewscreensaver"
PRJ_NAME="WebViewScreenSaver"
BUILD_DIR="build"

printf 'Building %s...' "$PRJ_NAME"
cd "$PRJ_NAME" || exit 1
mkdir "$BUILD_DIR"
xcodebuild -project WebViewScreenSaver.xcodeproj \
 -scheme WebViewScreenSaver \
 -configuration Release clean archive \
 -archivePath "$BUILD_DIR/build.xcarchive" \
 CODE_SIGN_IDENTITY="-" CODE_SIGNING_REQUIRED=YES > "$BUILD_DIR/build.log"
printf ' Done\n'

printf 'Installing %s...' "$PRJ_NAME"
cp -pr "$(find "$BUILD_DIR" -iname "*.saver")" "${HOME}/Library/Screen Savers"
printf ' Done\n'
