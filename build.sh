#!/usr/bin/env bash

VERSION="0.2.1"

makeself bin/ "fortressone-${VERSION}.run" 'FortressOne - A QuakeWorld Team Fortress installer' ./setup.sh

cp README_TEMPLATE.md README.md
sed -i "s|VERSION|${VERSION}|g" README.md
