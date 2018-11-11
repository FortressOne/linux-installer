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
  printf "Target directory already exists. Continue? [y]: "
  read -r CONTINUE
  if [ "$CONTINUE" != "" ] && [ "$CONTINUE" != "y" ] && [ "$CONTINUE" != "Y" ]; then
    error "ERROR: Installation aborted."
  fi
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

echo "Downloading FortressOne 3.1.0 client"
wget -nv --show-progress https://github.com/FortressOne/ezquake-source/releases/download/v3.1.0/fortressone-linux-x86_64

echo "Downloading FortressOne fragfile.dat"
wget -nv --show-progress https://github.com/FortressOne/ezquake-source/releases/download/v3.1.0/fragfile.dat

echo "Downloading server browser sources"
wget -nv --show-progress https://github.com/FortressOne/ezquake-source/releases/download/v3.1.0/sb.zip

echo "Downloading FortressOne client media files"
wget -nv --show-progress https://github.com/FortressOne/ezquake-media/releases/download/v1.0.0/fortressone.pk3

echo "Downloading Quake shareware media files"
mkdir id1/
wget -nv --show-progress https://s3-ap-southeast-2.amazonaws.com/qwtf/paks/id1/pak0.pak -P id1/

echo "Downloading FortressOne server media files"
mkdir fortress/
wget -nv --show-progress https://github.com/FortressOne/assets/releases/download/1.0.0/pak0.pk3 -P fortress/

echo "Downloading default configuration files"
wget -nv --show-progress https://github.com/FortressOne/fortress-one-cfgs/archive/master.zip

echo "Installing FortressOne 3.1.0 client"
cp fortressone-linux-x86_64 "$TARGET"
chmod +x "$TARGET/fortressone-linux-x86_64"
mkdir "$TARGET/ezquake"
mkdir "$TARGET/id1"
mkdir "$TARGET/fortress"

echo "Installing FortressOne fragfile.dat"
cp fragfile.dat "$TARGET/fortress"

echo "Installing server browser sources"
unzip -qq sb.zip
cp -r sb/ "$TARGET/ezquake"

echo "Installing Quake shareware pak file"
cp -r id1/ "$TARGET"

echo "Installing FortresOne pak file"
cp -r fortress/ "$TARGET"

echo "Installing FortressOne client media files"
cp fortressone.pk3 "$TARGET/fortress"

echo "Installing FortressOne default config files"
unzip -qq master.zip
cp -r fortress-one-cfgs-master/* "$TARGET"

# Update .desktop database
update-desktop-database --quiet "$HOME/.local/share/applications"

echo "FortressOne installed successfully"
