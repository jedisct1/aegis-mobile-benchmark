#! /bin/sh

export XCODEDIR="$(xcode-select -p)"
export IOS_VERSION_MIN=${IOS_VERSION_MIN-"18.0.0"}
export BASEDIR="${XCODEDIR}/Platforms/iPhoneOS.platform/Developer"
export PATH="${BASEDIR}/usr/bin:$BASEDIR/usr/sbin:$PATH"
export SDK="${BASEDIR}/SDKs/iPhoneOS.sdk"

export CFLAGS="-O3 -mcpu=apple-a15 -arch arm64 -isysroot ${SDK} -mios-version-min=${IOS_VERSION_MIN}"
export LDFLAGS="-arch arm64 -isysroot ${SDK} -mios-version-min=${IOS_VERSION_MIN}"

mkdir -p objs
cd objs
clang $CFLAGS -flto -c ../src/*/*.c -I ../src/include
ar r libaegis-ios.a *.o
rm -f *.o
ranlib libaegis-ios.a
ls -l libaegis-ios.a
