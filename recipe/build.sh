#! /usr/bin/bash

[ -f "$PREFIX/lib/libHepMC2.so" ] && ln -sf libHepMC2.so $PREFIX/lib/libHepMC.so
[ -f "$PREFIX/lib/libHepMC3.so" ] && ln -sf libHepMC3.so $PREFIX/lib/libHepMC.so

if [ -f "CMakeLists.txt" ]; then
  mkdir build
  cd build
  cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_CXX_STANDARD=17
else
  ./configure --prefix=$PREFIX --with-hepmc=$PREFIX
fi

make -j$(nproc)
make install
