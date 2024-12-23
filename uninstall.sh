#!/bin/bash

INSTALL_DIR="$HOME/.tpet"
SYMLINK="/usr/local/bin/tpet"

echo "Uninstalling TPet..."

if [ -L "$SYMLINK" ]; then
  sudo rm "$SYMLINK"
  echo "Removed Symlink from $SYMLINK"
else
  echo "No Symlink found at $SYMLINK. Was TPet installed correctly?"
  echo "Skipping..."
fi 

if [ -d "$INSTALL_DIR" ]; then
  rm -rf "$INSTALL_DIR"
  echo "Deleted $INSTALL_DIR"
else
  echo "Installation directory not found at $INSTALL_DIR. Was TPet installed correctly?"
  echo "Skipping..."
fi

echo "TPet uninstaller finished."
