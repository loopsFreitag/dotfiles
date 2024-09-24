#!/bin/bash

DOTFILES_DIR=~/dotfiles

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "@@@  you should already have installed zsh   @@@"
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

# Make zsh default
chsh -s /bin/zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Dependencies from oh-my-zsh
clone_repo() {
    local zsh_custom_dir=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
    local repo_name=$(basename "$repo_url" .git)
    local dest_dir="$zsh_custom_dir/$repo_name"
    local repo_url=$1

    if [ -d "$dest_dir" ]; then
        echo "Directory '$dest_dir' already exists. Skipping."
        return 1
    fi
    echo "Cloning '$repo_url' into '$dest_dir'..."
    git clone "$repo_url" "$dest_dir" 
}

REPOS=(
    "https://github.com/zsh-users/zsh-autosuggestions"
    "https://github.com/zsh-users/zsh-syntax-highlighting"
    "https://github.com/zsh-users/zsh-completions"
)

for repo in "${REPOS[@]}"; do
    custom_dir=""
    clone_repo "$repo" "$custom_dir"
done

# Create symlinks
ln -sf $DOTFILES_DIR/.zshrc ~/.zshrc
ln -sf $DOTFILES_DIR/.p10k.zsh ~/.p10k.zsh
ln -sf $DOTFILES_DIR/lvim ~/.config/lvim
ln -sf $DOTFILES_DIR/polybar ~/.config/polybar
ln -sf $DOTFILES_DIR/.gitconfig ~/.gitconfig

echo "Dotfiles have been symlinked!"

echo "installing p10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

