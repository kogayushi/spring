#!/bin/sh

# used in .travis.yml

set -e

# sdl2
#sudo add-apt-repository --yes ppa:bartbes/love-stable
# cmake
#sudo add-apt-repository --yes ppa:george-edison55/precise-backports
# gcc 4.7
#sudo add-apt-repository --yes ppa:ubuntu-toolchain-r/test
# boost
#sudo add-apt-repository --yes ppa:boost-latest/ppa

#libstreflop-dev
sudo add-apt-repository --yes ppa:kip/streflop
sudo apt-get update -qq

