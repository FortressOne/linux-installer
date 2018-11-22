#!/usr/bin/env bash

VERSION="1.0.0"

makeself bin/ "fortressone-linux-installer-${VERSION}.run" 'FortressOne - QuakeWorld Team Fortress package for Linux' ./setup.sh

cp README_TEMPLATE.md README.md
sed -i "s|VERSION|${VERSION}|g" README.md
