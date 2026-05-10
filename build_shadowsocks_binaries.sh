#!/bin/sh


# we can't use rust-android-gradle to build shadowsocks-rust, since it uses functionality that 
# breaks with gradle 9. Rust binaries for shadowsocks can be built via shadowsocks-android which
# uses the plugin...
# Rust Android Gradle Plugin:
# https://github.com/mozilla/rust-android-gradle/
# Open PR for gradle 9 support:
# https://github.com/mozilla/rust-android-gradle/pull/168


echo "obtaining shadowsocks-android..."
cd ..
git clone https://github.com/bitmold/shadowsocks-android
cd shadowsocks-android
git submodule update --init --recursive

echo ""
echo "to install rust if needed"
echo "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"

echo ""
echo "adding android native targets for rust"
rustup target add armv7-linux-androideabi aarch64-linux-android i686-linux-android x86_64-linux-android

echo ""
echo "building shadowsocks-android..."
./gradlew assembleRelease

cd core/build/rustJniLibs/android/
echo "built shadowsocks-android binaries:"
ls -al *

echo ""
read -p "do you want to overwrite the binaries in orbot? (yes/no) " yn
if [ "$yn" = "yes" ]; then
 	mv arm64-v8a/libsslocal.so ~/gp/orbot/app/src/main/jniLibs/arm64-v8a/libsslocal.so 
 	mv armeabi-v7a/libsslocal.so ~/gp/orbot/app/src/main/jniLibs/armeabi-v7a/libsslocal.so 
	mv x86/libsslocal.so ~/gp/orbot/app/src/main/jniLibs/x86/libsslocal.so 
	mv x86_64/libsslocal.so ~/gp/orbot/app/src/main/jniLibs/x86_64/libsslocal.so 
fi
