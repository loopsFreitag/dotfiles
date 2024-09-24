#!/bin/bash

DOTFILES_DIR=~/dotfiles

# Create symlinks for Zsh and Vim dotfiles
ln -sf $DOTFILES_DIR/.zshrc ~/.zshrc
ln -sf $DOTFILES_DIR/.p10k.zsh ~/.p10k.zsh
ln -sf $DOTFILES_DIR/lvim ~/.config/lvim
ln -sf $DOTFILES_DIR/polybar ~/.config/polybar
ln -sf $DOTFILES_DIR/.gitconfig ~/.gitconfig

echo "Dotfiles have been symlinked!"

