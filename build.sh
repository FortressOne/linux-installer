#!/usr/bin/env bash

VERSION="1.0.0"

makeself bin/ "fortressone-${VERSION}.run" 'FortressOne - A QuakeWorld Team Fortress package' ./setup.sh

cp README_TEMPLATE.md README.md
sed -i "s|VERSION|${VERSION}|g" README.md
