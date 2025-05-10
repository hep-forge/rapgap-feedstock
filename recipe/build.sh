#! /usr/bin/bash

[ -f "$PREFIX/lib/libHepMC2.so" ] && ln -sf libHepMC2.so $PREFIX/lib/libHepMC.so
[ -f "$PREFIX/lib/libHepMC3.so" ] && ln -sf libHepMC3.so $PREFIX/lib/libHepMC.so

./configure --prefix=$PREFIX --with-hepmc=$PREFIX

make -j$(nproc)
make install
