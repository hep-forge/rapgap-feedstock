#! /usr/bin/bash

# Ensure HepMC symlink
[ -f "$PREFIX/lib/libHepMC2.so" ] && ln -sf libHepMC2.so "$PREFIX/lib/libHepMC.so"
[ -f "$PREFIX/lib/libHepMC3.so" ] && ln -sf libHepMC3.so "$PREFIX/lib/libHepMC.so"

# Set CXX standard flags
export CXXFLAGS="-std=c++17 ${CXXFLAGS:-}"

if [ -f "CMakeLists.txt" ]; then
  mkdir -p build
  cd build
  cmake .. \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_CXX_STANDARD_REQUIRED=ON \
    -DCMAKE_CXX_EXTENSIONS=OFF \
    -DCMAKE_CXX_FLAGS="$CXXFLAGS"
else
  ./configure --prefix="$PREFIX" --with-hepmc="$PREFIX" CXXFLAGS="$CXXFLAGS"
fi

make -j"$(nproc)"
make install
