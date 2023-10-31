#!/bin/bash

set -e

set -v

export PATH=$DEPOT_TOOLS:$PATH

cd ${SOURCE_DIR}

if [ "$(uname)" == "Linux" ]; then
if [ "$TARGET_ARCH" == "arm" ]; then
  python build/linux/sysroot_scripts/install-sysroot.py --arch=arm
elif [ "$TARGET_ARCH" == "arm64" ]; then
  python build/linux/sysroot_scripts/install-sysroot.py --arch=arm64
else
  python build/linux/sysroot_scripts/install-sysroot.py --arch=amd64
fi
fi

# NOTE(mroberts): Running hooks generates this file, but running hooks also
# takes too long in CI; so do this manually.
(cd build/util && python lastchange.py -o LASTCHANGE)


#strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep GLIBCXX
#ls -la /usr/lib/x86_64-linux-gnu/libstdc++.so.6
#ln -sf /usr/lib/x86_64-linux-gnu/libstdc+.so.6 build/external/libwebrtc/download/src/third_party/llvm-build/Release+Asserts/lib/libstdc++.so.6
#ls -la build/external/libwebrtc/download/src/third_party/llvm-build/Release+Asserts/lib/libstdc++.so.6


# err
# /app/node-webrtc/build/external/libwebrtc/download/src/third_party/llvm-build/Release+Asserts/bin/../lib/libstdc++.so.6:
# version `GLIBCXX_3.4.30' not found (required by /lib/x86_64-linux-gnu/libicuuc.so.72)

# inspect
# #strings /app/node-webrtc/build/external/libwebrtc/download/src/third_party/llvm-build/Release+Asserts/lib/libstdc++.so.6

# link proper libstdc++.so.6

rm /app/node-webrtc/build/external/libwebrtc/download/src/third_party/llvm-build/Release+Asserts/lib/libstdc++.so.6
ln -sf /usr/lib/x86_64-linux-gnu/libstdc+.so.6 /app/node-webrtc/build/external/libwebrtc/download/src/third_party/llvm-build/Release+Asserts/lib/libstdc++.so.6

gn gen ${BINARY_DIR} "--args=${GN_GEN_ARGS}"
