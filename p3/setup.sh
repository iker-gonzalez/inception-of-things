#!/bin/bash

# Check if Homebrew is installed, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew recipes
brew update

# Check if Docker is installed and install it if it's not
if test ! $(which docker); then
    echo "Installing Docker..."
    brew install --cask docker
fi

# Check if k3d is installed and install it if it's not
if test ! $(which k3d); then
    echo "Installing k3d..."
    brew install k3d
fi

# Verify that Docker is installed correctly
docker run hello-world

# Verify that k3d is installed correctly
k3d version