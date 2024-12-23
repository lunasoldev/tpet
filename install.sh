#!/bin/bash

INSTALL_DIR="$HOME/.tpet"
REPO_URL="https://github.com/lunasoldev/tpet.git"

echo "Installing TPet..."
if ! command -v cowsay &> /dev/null; then
  echo "WARNING: cowsay is not installed!"
  echo "Please install cowsay manually."
  echo "TPet will still install, but will not run properly without cowsay."
fi 

if [ -d "$INSTALL_DIR" ]; then
  echo "Updating TPet..."
  cd "$INSTALL_DIR" && git pull
else
  echo "Cloning TPet from $REPO_URL into $INSTALL_DIR"
  git clone "$REPO_URL" "$INSTALL_DIR"
fi 

echo "Setting tpet.sh as executable..."
chmod +x "$INSTALL_DIR/tpet.sh"

echo "Creating Symlink from $INSTALL_DIR/tpet.sh to /usr/local/bin/tpet..."
sudo ln -sf "$INSTALL_DIR/tpet.sh" /usr/local/bin/tpet

echo "TPet successfully installed! Run it by using 'tpet'..."
