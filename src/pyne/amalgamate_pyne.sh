#!/bin/bash

# take 2 arguments:
# $1 location of the pyne source folder
# $2 destination of the amalgamated files

set -e

# Update amalgamated pyne

cd $1/pyne/src
python atomicgen.py
cd ..
sed -i "s/with open(filename, 'rt', encoding='utf-8') as f:/with open(filename, 'rt') as f:/g" amalgamate.py
python amalgamate.py -f license.txt src/utils.* src/extra_types.h src/h5wrap.h \
    src/state_map.cpp src/nucname.* src/rxname.* src/particle.* src/data.* \
    src/json-forwards.h src/json.h src/jsoncpp.cpp src/jsoncustomwriter.* \
    src/material.* src/material_library.* src/tally.* src/atomic_data.* src/measure.* \
    src/source_sampling.*
cp pyne.cpp pyne.h $2

githash=`git rev-parse HEAD`
cd $2
python $1/remove_unsupported.py
mv -fv pyne.cpp.new pyne.cpp

# Update source.F90
cp -v $1/pyne/share/source.F90       $1/../mcnp/mcnp5/pyne_source/source.F90
cp -v $1/pyne/share/source_mcnp6.F90 $1/../mcnp/mcnp6/pyne_source/source.F90

