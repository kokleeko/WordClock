#!/bin/bash

SCRIPT_DIR=$(realpath $(dirname "$0"))
PROJECT_DIR=$(realpath $SCRIPT_DIR/..)
PROJECT_NAME=$(basename $PROJECT_DIR)
BUILD_DIR=$PROJECT_DIR/apple/ios/build

mkdir -p $BUILD_DIR && cd $_
$Qt_DIR_IOS/bin/qmake -d $PROJECT_DIR/$PROJECT_NAME.pro >> $PROJECT_DIR/qmake.log 2>&1

SCHEMES=$(xcodebuild -list -json | tr -d "\n")
DEFAULT_SCHEME=$(echo $SCHEMES | ruby -e "require 'json'; puts JSON.parse(STDIN.gets)['project']['targets'][0]")

xcodebuild -scheme $DEFAULT_SCHEME -project $PROJECT_NAME.xcodeproj -configuration Release -destination 'generic/platform=iOS'
open $PROJECT_NAME.xcodeproj