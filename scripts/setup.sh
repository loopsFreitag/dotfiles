#!/bin/bash

DOTFILES_DIR=~/dotfiles

# Create symlinks for Zsh and Vim dotfiles
ln -sf $DOTFILES_DIR/.zshrc ~/.zshrc
ln -sf $DOTFILES_DIR/.p10k.zsh ~/.p10k.zsh

# Symlink for LunarVim configuration
ln -sf $DOTFILES_DIR/lvim ~/.config/lvim

# Symlink for Polybar configuration
ln -sf $DOTFILES_DIR/polybar ~/.config/polybar


echo "Dotfiles have been symlinked!"

