#!/usr/bin/env bash

error() {
    echo
    printf "%s\n" "$*"
    exit 1
}

[ "$(which unzip)" ] || error "ERROR: The package 'unzip' is not installed. Please install it and run the installation again."
[ "$(which tar)" ] || error "ERROR: The package 'tar' is not installed. Please install it and run the installation again."
[ "$(which wget)" ] || error "ERROR: The package 'wget' is not installed. Please install it and run the installation again."
[ "$(which desktop-file-install)" ] || error "ERROR: The package 'desktop-file-utils' is not installed. Please install it and run the installation again."
[ "$(which desktop-file-validate)" ] || error "ERROR: The package 'desktop-file-utils' is not installed. Please install it and run the installation again."
[ "$(which update-desktop-database)" ] || error "ERROR: The package 'desktop-file-utils' is not installed. Please install it and run the installation again."

TARGET="$HOME/bin/fortressone"

printf "Choose installation directory [%s]: " "$TARGET"
read -r INSTALL_DIR

if [ ! -z "$INSTALL_DIR" ]; then
  TARGET=$INSTALL_DIR
fi

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

mkdir -p "$TARGET"

# Install .desktop file
desktop-file-install --dir "$HOME/.local/share/applications" --rebuild-mime-info-cache fortressone.desktop

# Check directory succesfully created
if [ ! -d "$TARGET" ]; then
  error "ERROR: Target directory failed to create."
fi

# Installing logo
cp logo.png "$TARGET"

echo "Downloading ezQuake 3.1 full"
wget -nv --show-progress https://github.com/ezQuake/ezquake-source/releases/download/3.1/ezquake3.1-linux64-full.tar.gz

echo "Downloading ezQuake 3.1 binary"
wget -nv --show-progress https://s3-ap-southeast-2.amazonaws.com/qwtf/ezquake31/ezquake-linux-x86_64

echo "Downloading FortressOne media files"
wget -nv --show-progress https://s3-ap-southeast-2.amazonaws.com/qwtf/fortress-one-gfx.zip

echo "Downloading Quake shareware media files"
mkdir id1/
wget -nv --show-progress https://s3-ap-southeast-2.amazonaws.com/qwtf/paks/id1/pak0.pak -P id1/

echo "Downloading FortressOne media files"
mkdir fortress/
wget -nv --show-progress https://s3-ap-southeast-2.amazonaws.com/qwtf/paks/fortress/pak0.pak -P fortress/

echo "Downloading default configuration files"
wget -nv --show-progress https://github.com/FortressOne/fortress-one-cfgs/archive/master.zip

echo "Installing ezQuake 3.1 full"
tar -xf ezquake3.1-linux64-full.tar.gz -C "$TARGET"

echo "Installing ezQuake 3.1 binary"
cp ezquake-linux-x86_64 "$TARGET"

echo "Installing Quake shareware pak file"
cp id1/pak0.pak "$TARGET/id1/"

echo "Installing FortresOne pak file"
mkdir -p "$TARGET/fortress/"
cp fortress/pak0.pak "$TARGET/fortress/"

echo "Installing FortressOne gfx files"
unzip -qq fortress-one-gfx.zip -d "$TARGET"

echo "Installing FortressOne default config files"
unzip -qq master.zip
cp -r fortress-one-cfgs-master/* "$TARGET"

# Update .desktop database
update-desktop-database --quiet "$HOME/.local/share/applications"

echo "FortressOne installed successfully"
