#! /usr/bin/bash

# Ensure HepMC symlink
[ -f "$PREFIX/lib/libHepMC2.so" ] && ln -sf libHepMC2.so "$PREFIX/lib/libHepMC.so"
[ -f "$PREFIX/lib/libHepMC3.so" ] && ln -sf libHepMC3.so "$PREFIX/lib/libHepMC.so"

# Set CXX standard flags
export ROOT_CXX_STANDARD=$(root-config --cflags | sed -n 's/.*-std=c++\([0-9]*\).*/\1/p')
export CXXFLAGS="-std=c++${ROOT_CXX_STANDARD} ${CXXFLAGS:-}"
if [ -f "CMakeLists.txt" ]; then
  mkdir -p build
  cd build
  # ${CMAKE_ARGS} carries conda-build's own -DCMAKE_BUILD_TYPE=Release
  # (plus toolchain/strip paths) -- this cmake invocation omitted it
  # entirely, so CMAKE_BUILD_TYPE stayed unset (rapgap's own
  # CMakeLists.txt never defaults it either), producing an unoptimized,
  # unstripped debug-info binary. Every other cmake-based build.sh in
  # this fleet interpolates ${CMAKE_ARGS} for exactly this reason.
  cmake .. ${CMAKE_ARGS} -DCMAKE_INSTALL_PREFIX="$PREFIX" -DCMAKE_CXX_STANDARD=${ROOT_CXX_STANDARD}
else
  ./configure --prefix="$PREFIX" --with-hepmc="$PREFIX" CXXFLAGS="$CXXFLAGS"
fi

make -j"$(nproc)"
make install
