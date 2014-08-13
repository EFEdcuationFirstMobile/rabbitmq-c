#!/usr/bin/env bash

COLOR_RED=$(tput setaf 1)
COLOR_GOLD=$(tput setaf 178)
COLOR_AZURE=$(tput setaf 33)
COLOR_GREEN=$(tput setaf 28)
NORMAL=$(tput sgr0)

echo "${COLOR_GOLD}Building a fat rabbitmq-c library for iOS platform...${NORMAL}"

make maintainer-clean

autoreconf --install --verbose

echo "${COLOR_GREEN}Building i386 rabbitmq-c library for iOS Simulator...${NORMAL}"
make clean

./configure --host=i386-apple-darwin --with-ssl=no --enable-static \
  CC="/usr/bin/clang -arch i386" \
  LD=$DEVROOT/usr/bin/ld

make
lipo -info librabbitmq/.libs/librabbitmq.a
mv librabbitmq/.libs/librabbitmq.a librabbitmq.a.i386

echo "${COLOR_GREEN}Building x86_64 rabbitmq-c library for iOS Simulator...${NORMAL}"
make clean

./configure --host=i386-apple-darwin --with-ssl=no --enable-static \
  CC="/usr/bin/clang -arch x86_64" \
  LD=$DEVROOT/usr/bin/ld

make
lipo -info librabbitmq/.libs/librabbitmq.a
mv librabbitmq/.libs/librabbitmq.a librabbitmq.a.x86_64

echo "${COLOR_GREEN}Building armv7 rabbitmq-c library for iOS Simulator...${NORMAL}"
make clean

DEVROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer
SDKROOT=$DEVROOT/SDKs/iPhoneOS7.1.sdk
./configure --host=armv7-apple-darwin --enable-static --with-ssl=no \
  CC="/usr/bin/clang -arch armv7" \
  CPPFLAGS="-I$SDKROOT/usr/include/" \
  CFLAGS="$CPPFLAGS -pipe -no-cpp-precomp -isysroot $SDKROOT" \
  LD=$DEVROOT/usr/bin/ld

make
lipo -info librabbitmq/.libs/librabbitmq.a
mv librabbitmq/.libs/librabbitmq.a librabbitmq.a.armv7

echo "${COLOR_GREEN}Building armv7s rabbitmq-c library for iOS Simulator...${NORMAL}"
make clean

DEVROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer
SDKROOT=$DEVROOT/SDKs/iPhoneOS7.1.sdk
./configure --host=armv7s-apple-darwin --enable-static --with-ssl=no \
  CC="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -arch armv7s" \
  CPPFLAGS="-I$SDKROOT/usr/include/" \
  CFLAGS="$CPPFLAGS -pipe -no-cpp-precomp -isysroot $SDKROOT" \
  LD=$DEVROOT/usr/bin/ld

make
lipo -info librabbitmq/.libs/librabbitmq.a
mv librabbitmq/.libs/librabbitmq.a librabbitmq.a.armv7s

echo "${COLOR_GREEN}Building armv64 rabbitmq-c library for iOS Simulator...${NORMAL}"
make clean

DEVROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer
SDKROOT=$DEVROOT/SDKs/iPhoneOS7.1.sdk
./configure --host=aarch64-apple-darwin --enable-static --with-ssl=no \
  CC="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -arch arm64" \
  CPPFLAGS="-I$SDKROOT/usr/include/" \
  CFLAGS="$CPPFLAGS -pipe -no-cpp-precomp -isysroot $SDKROOT" \
  LD=$DEVROOT/usr/bin/ld

make
lipo -info librabbitmq/.libs/librabbitmq.a
mv librabbitmq/.libs/librabbitmq.a librabbitmq.a.arm64

DEVROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer
$DEVROOT/usr/bin/lipo -arch armv7 librabbitmq.a.armv7 -arch armv7s librabbitmq.a.armv7s -arch i386 librabbitmq.a.i386 -arch arm64 librabbitmq.a.arm64 -arch x86_64 librabbitmq.a.x86_64 -create -output librabbitmq.a

tput setaf 28 # Set green output
xcrun -sdk iphoneos lipo -info librabbitmq.a
tput sgr0 # Set back to normal output
