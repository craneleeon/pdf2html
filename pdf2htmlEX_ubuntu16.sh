#!/bin/bash
# Ubuntu Developer Script For pdf2htmlEx
#
#
# Downloads and configures the following:
#
#   CMake, pkg-config
#   GNU Getopt
#   GCC
#   poppler
#   fontforge
#   pdf2htmlEX


############################### How to use ###############################
# [sudo] chmod 775 pdf2htmlEX.sh
# [sudo] ./pdf2htmlEX.sh

HOME_PATH=$(cd ~/ && pwd)
LINUX_ARCH="$(lscpu | grep 'Architecture' | awk -F\: '{ print $2 }' | tr -d ' ')"
POPPLER_SOURCE="http://poppler.freedesktop.org/poppler-0.47.0.tar.xz"
FONTFORGE_SOURCE="https://github.com/fontforge/fontforge.git"
PDF2HTMLEX_SOURCE="https://github.com/coolwanglu/pdf2htmlEX.git"

echo 'export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc

if [ "$LINUX_ARCH" == "x86_64" ]; then
 
# apt-get install software-properties-common
# add-apt-repository -y ppa:fontforge/fontforge 
  echo "Updating all Ubuntu software repository lists ..."
apt-get update
  echo "Installing basic dependencies ..."
apt-get install -qq -y cmake gcc libgetopt++-dev git curl wget m4 autoconf automake libtool
apt-get install -qq -y pkg-config libopenjpeg-dev libfontconfig1-dev libfontforge-dev poppler-data poppler-utils poppler-dbg
apt-get install -qq -y packaging-dev pkg-config python-dev libpango1.0-dev libglib2.0-dev libxml2-dev giflib-dbg libopenjp2-tools
apt-get install -qq -y libjpeg-dev libtiff-dev uthash-dev libspiro-dev libcairo2-dev libpango-1.0-0 libpango1.0-dev libpangocairo-1.0-0 libpangoxft-1.0-0
# apt-get install -qq -y fontforge 

  echo "Installing fontforge ..."
cd "$HOME_PATH"
git clone --depth 1 "$FONTFORGE_SOURCE"
cd fontforge/
./bootstrap
./configure --prefix=/usr
make
make install

  echo "Installing Poppler ..."
cd "$HOME_PATH"
wget "$POPPLER_SOURCE"
tar -xvf poppler-0.47.0.tar.xz
cd poppler-0.47.0/
./configure --prefix=/usr               \
            --sysconfdir=/etc           \
            --enable-build-type=release \
            --enable-xpdf-headers       
make
make install

cd "$HOME_PATH"
wget http://poppler.freedesktop.org/poppler-data-0.4.7.tar.gz
tar -xf poppler-data-0.4.7.tar.gz
cd poppler-data-0.4.7
make prefix=/usr install 


  echo "Installing Pdf2htmlEx ..."
cd "$HOME_PATH"
git clone --depth 1 "$PDF2HTMLEX_SOURCE"
cd pdf2htmlEX/
cmake .
make
make install


cd "$HOME_PATH" && rm -rf "poppler-0.47.0.tar.xz"
cd "$HOME_PATH" && rm -rf "poppler-0.47.0"
cd "$HOME_PATH" && rm -rf "poppler-data-0.4.7.tar.gz"
cd "$HOME_PATH" && rm -rf "poppler-data-0.4.7"
cd "$HOME_PATH" && rm -rf "pdf2htmlEX"
cd "$HOME_PATH" && rm -rf "fontforge"

else
  echo "********************************************************************"
  echo "This script currently doesn't supports $LINUX_ARCH Linux archtecture"
fi
 
echo "----------------------------------"
echo "Restart your Ubuntu session for installation to complete..."

