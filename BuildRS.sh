#!/bin/bash
echo 'Compile RecStrip from a specific source tag/branch'
echo '(c) 2024 Christian Wuensch'
echo

if [ "$1" == "-h" ] ; then
  echo "Usage:  $0 [<tag/branch>] [<output_name>]"
  echo
  exit 0
fi

cd "$(dirname "${BASH_SOURCE[0]}")"

OUTPUT=bin/RecStrip_ref
if [ -n "$2" ] ; then OUTPUT="$2" ; fi
if [ -n "$1" ] ; then BRANCH="--branch $1" ; fi

rm -rf RS


if [ -n "$1" ] ; then
  # Install required tools
#  apt-get -y install wget unzip

  # Try to download pre-compiled release
  wget -q -O RecStrip_ref.zip "https://github.com/cwuensch/RecStrip/releases/download/$1/RecStrip_Linux.zip"

  # Unzip
  if [ -f RecStrip_ref.zip ] ; then
    mkdir RS
    unzip RecStrip_ref.zip -d RS/
  fi
  rm RecStrip_ref.zip
fi


if [ ! -f RS/RecStrip ] ; then
  # Install Git client
#  apt-get -y install git

  # Checkout RecStrip from source
  git clone --depth 1 $BRANCH https://github.com/cwuensch/RecStrip.git RS
  cd RS

  # Adapt Makefile for non-Topfield Unix
  sed -i 's/-DLINUX -D_REENTRANT -static //' Makefile
  sed -i '/include \${BASE}\/include\/tool.mk/d' Makefile

  # Adapt Makefile for x86
  sed -i 's/CFLAGS   +=/CFLAGS   += -m32/' Makefile
  sed -i 's/CXXFLAGS +=/CXXFLAGS += -m32/' Makefile
  sed -i 's/LDFLAGS  +=/LDFLAGS  += -m32/' Makefile

  # Compile RecStrip
  rm -f RecStrip *.o
  make
  cd ..
fi

# Move binary as reference to bin
mv RS/RecStrip $OUTPUT
