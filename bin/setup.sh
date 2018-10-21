#!/usr/bin/env bash

error() {
    echo
    printf "%s\n" "$*"
    exit 1
}

# Check for install dependencies
[ "$(which unzip)" ] || error "ERROR: The package 'unzip' is not installed. Please install it and run the installation again."
[ "$(which tar)" ] || error "ERROR: The package 'tar' is not installed. Please install it and run the installation again."
[ "$(which wget)" ] || error "ERROR: The package 'wget' is not installed. Please install it and run the installation again."
[ "$(which desktop-file-install)" ] || error "ERROR: The package 'desktop-file-install' is not installed. Please install it and run the installation again."

TARGET="$HOME/bin/fortressone"

printf "Choose installation directory [%s]: " "$TARGET"
read -r INSTALL_DIR

if [ ! -z "$INSTALL_DIR" ]; then
  TARGET=$INSTALL_DIR
fi

# check if directory already exists
if [ -d "$TARGET" ]; then
  error "ERROR: Target directory already exists."
fi

# Configuring .desktop file
sed -i "s|INSTALL_DIR|$TARGET|g" fortressone.desktop

# Validate .desktop file
if [ $(desktop-file-validate fortressone.desktop) ]; then
  error "ERROR: Invalid .desktop file."
fi

echo "Installing to $TARGET"

# Creating installation directory
mkdir -p "$TARGET"

# Install .desktop file
sudo desktop-file-install fortressone.desktop
sudo update-desktop-database

# Check directory succesfully created
if [ ! -d "$TARGET" ]; then
  error "ERROR: Target directory failed to create."
fi

# Installing logo
cp logo.png "$TARGET"

# get the ezquake linux package
wget https://github.com/ezQuake/ezquake-source/releases/download/3.1/ezquake3.1-linux64-full.tar.gz
# untar to install directory
tar -xvf ezquake3.1-linux64-full.tar.gz -C "$TARGET"

# get ezquake31 binary compiled against Ubuntu 18.04
wget https://s3-ap-southeast-2.amazonaws.com/qwtf/ezquake31/ezquake-linux-x86_64
# copy to install dir
cp ezquake-linux-x86_64 "$TARGET"

# get fortressone media files
wget https://s3-ap-southeast-2.amazonaws.com/qwtf/fortress-one-gfx.zip
# unzip to install directory
unzip fortress-one-gfx.zip -d "$TARGET"

# get shareware quake pak0.pak
mkdir id1/
wget https://s3-ap-southeast-2.amazonaws.com/qwtf/paks/id1/pak0.pak -P id1/
# copy to install dir
cp id1/pak0.pak "$TARGET/id1/"

# get tf2.9 fortress.pak
mkdir fortress/
wget https://s3-ap-southeast-2.amazonaws.com/qwtf/paks/fortress/pak0.pak -P fortress/
# copy to install dir
cp fortress/pak0.pak "$TARGET/fortress"

# get cfgs
wget https://github.com/FortressOne/fortress-one-cfgs/archive/master.zip
unzip master.zip
cp -r fortress-one-cfgs-master/* "$TARGET"
