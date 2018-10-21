#!/usr/bin/env bash

error() {
    echo
    printf "%s\n" "$*"
    exit 1
}

# Check for install dependencies
[ `which unzip` ] || error "ERROR: The package 'unzip' is not installed. Please install it and run the installation again."
[ `which tar` ] || error "ERROR: The package 'tar' is not installed. Please install it and run the installation again."
[ `which wget` ] || error "ERROR: The package 'wget' is not installed. Please install it and run the installation again."
[ `which desktop-file-install` ] || error "ERROR: The package 'desktop-file-install' is not installed. Please install it and run the installation again."

TARGET="$HOME/bin/fortressone"

printf "Choose installation directory [${TARGET}]: "
read INSTALL_DIR

if [ ! -z $INSTALL_DIR ]; then
  TARGET=$INSTALL_DIR
fi

echo $TARGET
error "exit"

# get install directory (default ~/bin/fortressone)
echo "Installing to $TARGET"

# check if directory already exists
if [ -d "$TARGET" ]; then
  error "ERROR: Target directory already exists."
fi

# Creating installation directory
mkdir -p $TARGET

# Check directory succesfully created
if [ ! -d "$TARGET" ]; then
  error "ERROR: Target directory failed to create."
fi

# Installing logo
cp logo.png $TARGET

# Checking for .desktop file location
if [ ! -d "/usr/share/applications" ]; then
  error "ERROR: /usr/share/applications directory doesn't exist"
fi

# Configuring .desktop file
sed -i "s|\$INSTALL_DIR|$TARGET|g" fortressone.desktop

# Installing .desktop file
# TODO: desktop-file-validate
sudo desktop-file-install fortressone.desktop

# get the ezquake linux package
wget https://github.com/ezQuake/ezquake-source/releases/download/3.1/ezquake3.1-linux64-full.tar.gz
# untar to install directory
tar -xvf ezquake3.1-linux64-full.tar.gz -C $TARGET

# get ezquake31 binary compiled against Ubuntu 18.04
wget https://s3-ap-southeast-2.amazonaws.com/qwtf/ezquake31/ezquake-linux-x86_64
# copy to install dir
cp ezquake-linux-x86_64 $TARGET

# get fortressone media files
wget https://s3-ap-southeast-2.amazonaws.com/qwtf/fortress-one-gfx.zip
# unzip to install directory
unzip fortress-one-gfx.zip -d $TARGET

# get shareware quake pak0.pak
mkdir id1/
wget https://s3-ap-southeast-2.amazonaws.com/qwtf/paks/id1/pak0.pak -P id1/
# copy to install dir
cp id1/pak0.pak $TARGET/id1/

# get tf2.9 fortress.pak
mkdir fortress/
wget https://s3-ap-southeast-2.amazonaws.com/qwtf/paks/fortress/pak0.pak -P fortress/
# copy to install dir
cp fortress/pak0.pak $TARGET/fortress

# get cfgs
wget https://github.com/FortressOne/fortress-one-cfgs/archive/master.zip
unzip master.zip
cp -r fortress-one-cfgs-master/* $TARGET
