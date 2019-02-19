#!/usr/bin/env bash

# Exit on error
set -e

success () {
  printf "\\033[32m ✔ \\033[0m\\n"
}

fail () {
  printf "\\033[31m ✖ \\033[0m $1\\n"
  exit 1
}

doing () {
  printf "\\033[33m ➜ \\033[0m $1"
}

# Define variables
# dotfiles location
DOTLOC=$HOME/.dotfiles
# Set current directory as ROOT.(~/.dotfiles)
ROOT="$(pwd)"
# Path to oh-my-zsh custom folder
ZSHCUSTOMPATH=$HOME/.oh-my-zsh/custom

# exit if macos is not found
doing "Checking system..."
if [[ $(uname) != 'Darwin' ]]; then
  fail "You are not on a mac."
else
  success
fi

# exit if dotfiles exists
doing "Looking for dotfiles..."
if [[ -d  $DOTLOC ]]; then
  fail "\\033[2m$HOME/dotfiles\\033[0m already exists."
else
  success
fi

# No help from next launch
touch ~/.hushlogin

echo "# The mere presence of this file in the home directory disables the system
# copyright notice, the date and time of the last login, the message of the
# day as well as other information that may otherwise appear on login.
# See \`man login\`." > .hushlogin

# create dotfiles directory and clone
doing "Cloning dotfiles..."
git clone -q https://github.com/ad1tyara0/dotfiles.git "$HOME"
success

main () {

  source macosprep.sh
  source brew.sh
  source setup-vscode.sh

  # link required files
  doing "Linking Files..."

  # Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
  rm -rf $HOME/.zshrc
  ln -s $ROOT/zsh/.zshrc $HOME/.zshrc

  # Removes aliases.zsh from $CUSTOMPATH (if it exists) and symlinks the .aliases.zsh file from the .dotfiles
  rm -rf $ZSHCUSTOMPATH/aliases.zsh
  ln -s $ROOT/zsh/aliases.zsh $ZSHCUSTOMPATH/aliases.zsh

  # Removes .gitignore from $HOME (if it exists) and symlinks the ..gitignore file from the .dotfiles
  rm -rf $HOME/.gitignore
  ln -s $ROOT/.gitignore $HOME/.gitignore

  # Removes .gitconfig from $HOME (if it exists) and symlinks the .gitconfig file from the .dotfiles
  rm -rf $HOME/.gitconfig
  ln -s $ROOT/.gitconfig $HOME/.gitconfig

  # Move bullet-train prompt to oh-my-zsh custom folder
  cp $ROOT/zsh/themes/bullet-train.zsh-theme $ZSHCUSTOMPATH/themes/

  success

}

# Execute main()
main

echo Setting macOS preferences

# We will run this last because this will reload the shell
source macos.sh

echo All Done!
echo Restarting shell

exec "$(which $SHELL)" -l