#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q slack-desktop | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook:fix-namespaces.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/pixmaps/slack.png
export DESKTOP=/usr/share/applications/slack.desktop

# Deploy dependencies
mkdir -p ./AppDir/bin
cp -vr /usr/lib/slack/* ./AppDir/bin
quick-sharun ./AppDir/bin/*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
