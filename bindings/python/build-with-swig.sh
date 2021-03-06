#!/bin/bash
#
#
#    pHash, the open source perceptual hash library
#    Copyright (C) 2008-2009 Aetilius, Inc.
#    All rights reserved.
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#    Evan Klinger - eklinger@phash.org
#    David Starkweather - dstarkweather@phash.org
#    
#    swig interface by Loic Jaquemet - loic.jaquemet@gmail.com
#
# 
# @see http://realmike.org/python/swig_linux.htm for autotools integration
#
#
#Libraries have been installed in:
#   /usr/local/lib
#
#If you ever happen to want to link against installed libraries
#in a given directory, LIBDIR, you must either use libtool, and
#specify the full pathname of the library, or use the `-LLIBDIR'
#flag during linking and do at least one of the following:
#  - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
#     during execution
#   - add LIBDIR to the `LD_RUN_PATH' environment variable
#     during linking
#   - use the `-Wl,-rpath -Wl,LIBDIR' linker flag
#   - have your system administrator add LIBDIR to `/etc/ld.so.conf'
#
# if pHash is in /usr/local....
# export LD_LIBRARY_PATH=/usr/local/lib
#
# you will need a build pHash tree
# apt-get install swig python-dev imagemagick graphicsmagick
# 
#

PYTHONINC=`python-config --includes`

  echo "cleaning"
  rm -f pHash.py pHash.pyc pHash_wrap.cpp pHash_wrap.o _pHash.so
  python setup.py clean -a

  echo " swigging.... "
  swig -classic -I../../src/ -I/usr/include -c++ -python -o pHash_wrap.cpp pHash.i
  if [ $? -ne 0 ]; then
   exit 1
  fi

#echo "building ..."
#gcc -fPIC $PYTHONINC -I../../src/ -c pHash_wrap.cpp -o pHash_wrap.o
#if [ $? -ne 0 ]; then
# exit 1
#fi

#OBJECTS="../../src/audiophash.o  ../../src/cimgffmpeg.o  ../../src/pHash.o  ../../src/ph_fft.o"
#OBJECTS=""

#echo "making lib" 
#g++ -shared pHash_wrap.o $OBJECTS -lpHash -o _pHash.so
#if [ $? -ne 0 ]; then
# exit 1
#fi

  echo "building ..."
  #python setup.py build 


  echo "testing "
  export LD_LIBRARY_PATH=./build/lib.linux-i686-2.6/
  python -c  '
import pHash
print pHash.ph_about()
'
  if [ $? -ne 0 ]; then
    exit 1
  fi

  echo 'install'
# sudo python setup.py install
# need copy _pHash.so into the egg install...
#cp pHash.py _pHash.so /usr/local/lib/python2.5/site-packages/
#sudo python setup.py install
