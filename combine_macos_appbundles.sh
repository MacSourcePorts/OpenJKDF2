#!/bin/zsh

rm -rf OpenJKDF2_universal.app
cp -r OpenJKDF2.app OpenJKDF2_universal.app

rm -rf OpenJKDF2_universal.app/Contents/MacOS/openjkdf2-64.dsym
cp -r OpenJKDF2.app/Contents/MacOS/openjkdf2-64.dsym OpenJKDF2_universal.app/Contents/MacOS/openjkdf2-64_arm64.dsym
cp -r OpenJKDF2_x86_64.app/Contents/MacOS/openjkdf2-64.dsym OpenJKDF2_universal.app/Contents/MacOS/openjkdf2-64_x86_64.dsym

lipo -create -output OpenJKDF2_universal.app/Contents/MacOS/openjkdf2-64 OpenJKDF2.app/Contents/MacOS/openjkdf2-64 OpenJKDF2_x86_64.app/Contents/MacOS/openjkdf2-64
lipo -create -output OpenJKDF2_universal.app/Contents/MacOS/libGLEW.2.2.dylib OpenJKDF2.app/Contents/MacOS/libGLEW.2.2.dylib OpenJKDF2_x86_64.app/Contents/MacOS/libGLEW.2.2.dylib
lipo -create -output OpenJKDF2_universal.app/Contents/MacOS/libSDL2-2.0.0.dylib OpenJKDF2.app/Contents/MacOS/libSDL2-2.0.0.dylib OpenJKDF2_x86_64.app/Contents/MacOS/libSDL2-2.0.0.dylib
lipo -create -output OpenJKDF2_universal.app/Contents/MacOS/libSDL2_mixer-2.0.0.dylib OpenJKDF2.app/Contents/MacOS/libSDL2_mixer-2.0.0.dylib OpenJKDF2_x86_64.app/Contents/MacOS/libSDL2_mixer-2.0.0.dylib

lipo -create -output OpenJKDF2_universal.app/Contents/MacOS/libmodplug.1.dylib OpenJKDF2.app/Contents/MacOS/libmodplug.1.dylib OpenJKDF2_x86_64.app/Contents/MacOS/libmodplug.1.dylib
lipo -create -output OpenJKDF2_universal.app/Contents/MacOS/libmpg123.0.dylib OpenJKDF2.app/Contents/MacOS/libmpg123.0.dylib OpenJKDF2_x86_64.app/Contents/MacOS/libmpg123.0.dylib
lipo -create -output OpenJKDF2_universal.app/Contents/MacOS/libvorbis.0.dylib OpenJKDF2.app/Contents/MacOS/libvorbis.0.dylib OpenJKDF2_x86_64.app/Contents/MacOS/libvorbis.0.dylib
lipo -create -output OpenJKDF2_universal.app/Contents/MacOS/libvorbisfile.3.dylib OpenJKDF2.app/Contents/MacOS/libvorbisfile.3.dylib OpenJKDF2_x86_64.app/Contents/MacOS/libvorbisfile.3.dylib
lipo -create -output OpenJKDF2_universal.app/Contents/MacOS/libFLAC.8.dylib OpenJKDF2.app/Contents/MacOS/libFLAC.8.dylib OpenJKDF2_x86_64.app/Contents/MacOS/libFLAC.8.dylib
lipo -create -output OpenJKDF2_universal.app/Contents/MacOS/libogg.0.dylib OpenJKDF2.app/Contents/MacOS/libogg.0.dylib OpenJKDF2_x86_64.app/Contents/MacOS/libogg.0.dylib

install_name_tool -change /usr/local/opt/libogg/lib/libogg.0.dylib @executable_path/libogg.0.dylib OpenJKDF2_universal.app/Contents/MacOS/libFLAC.8.dylib
install_name_tool -change /opt/homebrew/opt/libogg/lib/libogg.0.dylib @executable_path/libogg.0.dylib OpenJKDF2_universal.app/Contents/MacOS/libFLAC.8.dylib

chmod 774 OpenJKDF2_universal.app/Contents/MacOS/openjkdf2-64
chmod 774 OpenJKDF2_universal.app/Contents/MacOS/*.dylib

codesign -s - OpenJKDF2_universal.app --force --deep --verbose

#tar czf macos-debug.tar.gz OpenJKDF2_universal.app