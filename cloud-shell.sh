#!/bin/bash

# Install Linuxbrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Linuxbrew to PATH
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install gcloud
brew install --cask google-cloud-sdk

# Install neovim
brew install neovim

# Install sql-client
brew install sql-cli
