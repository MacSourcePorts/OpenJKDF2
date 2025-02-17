#!/bin/zsh

export PATH="${HOMEBREW_PREFIX}/opt/llvm/bin:$PATH"

cd /Users/maxamillion/workspace/OpenJKDF2/

#make flex/flex
#make byacc/yacc

#cp DF2/player_bak/Max/Max.plr ~/.local/share/openjkdf2/player/Max/Max.plr
#OPENJKDF2_NO_ASAN=1 DEBUG_QOL_CHEATS=1 make -f Makefile.macos -j10 &&
mkdir -p build_darwin64 && cd build_darwin64

if [ ! -f build_protoc/protoc ]; then
    mkdir -p build_protoc && cd build_protoc
    cmake -DCMAKE_BUILD_TYPE=Release -Dprotobuf_BUILD_TESTS=OFF ../../3rdparty/protobuf/cmake
    make -j10 protoc
    cd ..
fi

if [ ! -f build_protobuf/libprotobuf.dylib ]; then
    mkdir -p build_protobuf && cd build_protobuf
    cmake -DCMAKE_INSTALL_PREFIX=. -DCMAKE_BUILD_TYPE=Release -Dprotobuf_BUILD_TESTS=OFF -Dprotobuf_BUILD_SHARED_LIBS=ON ../../3rdparty/protobuf/cmake
    make -j10 install
    cd ..
fi

if [ ! -f build_gns/bin/libGameNetworkingSockets.dylib ]; then
    mkdir -p build_gns && cd build_gns
    GNS_BUILD=$(pwd)
    export PKG_CONFIG_PATH_OLD=$PKG_CONFIG_PATH
    export PKG_CONFIG_PATH=$PKG_CONFIG_PATH_OLD:/opt/homebrew/opt/openssl@1.1/lib/pkgconfig
    cmake -DCMAKE_BUILD_TYPE=Release -DProtobuf_USE_STATIC_LIBS=ON -DProtobuf_LIBRARIES="-L$GNS_BUILD/../build_protobuf/lib" -DProtobuf_LIBRARIES_PATH="$GNS_BUILD/../build_protobuf/lib" -DProtobuf_INCLUDE_DIR=$GNS_BUILD/../../3rdparty/protobuf/src -DProtobuf_INCLUDE_DIR2=$GNS_BUILD/../build_protobuf/include -DProtobuf_PROTOC_EXECUTABLE=$GNS_BUILD/../build_protoc/protoc $GNS_BUILD/../../3rdparty/GameNetworkingSockets
    make -j10
    export PKG_CONFIG_PATH=$PKG_CONFIG_PATH_OLD
    cd ..
fi

export PKG_CONFIG_PATH_OLD=$PKG_CONFIG_PATH
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH_OLD:/opt/homebrew/opt/openssl@1.1/lib/pkgconfig
DEBUG_QOL_CHEATS=1 cmake .. &&
DEBUG_QOL_CHEATS=1 make -j10 &&
cd .. &&
#cp resource/shaders/* DF2/resource/shaders/ &&
mkdir -p ~/.local/share/openjkdf2/resource/shaders/ &&
cp resource/shaders/* ~/.local/share/openjkdf2/resource/shaders/ &&
echo "Running..." &&
#codesign -s - openjkdf2-64 &&
LSAN_OPTIONS="suppressions=/Users/maxamillion/workspace/OpenJKDF2/suppr.txt" ASAN_OPTIONS="log_path=/Users/maxamillion/workspace/OpenJKDF2/asan.log"  lldb -o run ./OpenJKDF2.app/Contents/MacOS/openjkdf2-64 #-- -verboseNetworking
#lldb -o run ./OpenJKDF2.app/Contents/MacOS/openjkdf2-64
#open OpenJKDF2.app


#LSAN_OPTIONS="suppressions=/Users/maxamillion/workspace/OpenJKDF2/suppr.txt" ASAN_OPTIONS="detect_leaks=1:log_path=/Users/maxamillion/workspace/OpenJKDF2/asan.log" ./OpenJKDF2.app/Contents/MacOS/openjkdf2-64 