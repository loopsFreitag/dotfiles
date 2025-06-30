#!/bin/bash

DOTFILES_DIR=~/.dotfiles

echo "Starting the installation of zsh, nvim, and related configurations."

# Detect package manager
if command -v apt > /dev/null; then
    PKG_MANAGER="apt"
elif command -v pacman > /dev/null; then
    PKG_MANAGER="pacman"
else
    echo "Unsupported package manager. Only apt and pacman are supported."
    exit 1
fi

install_package() {
    local package=$1
    if [ "$PKG_MANAGER" = "apt" ]; then
        sudo apt update
        sudo apt install -y $package
    elif [ "$PKG_MANAGER" = "pacman" ]; then
        sudo pacman -Sy --noconfirm $package
    fi
}

# Prompt for version
echo "Select the version to install:"
echo "1) Stable"
echo "2) Nightly"
read -p "Enter your choice (1/2): " VERSION_CHOICE

case "$VERSION_CHOICE" in
    1)
        VERSION="stable"
        ;;
    2)
        VERSION="nightly"
        ;;
    *)
        echo "Invalid choice. Please run the script again and choose '1' or '2'."
        exit 1
        ;;
esac

# Install zsh
if ! command -v zsh > /dev/null; then
    echo "Installing zsh"
    install_package zsh
else
    echo "zsh is already installed"
fi

# Make zsh default
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh"
    chsh -s $(which zsh)
else
    echo "zsh is already the default shell"
fi

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "oh-my-zsh is already installed"
fi

# Dependencies from oh-my-zsh
clone_repo() {
    local repo_url=$1
    local zsh_custom_dir=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
    local repo_name=$(basename "$repo_url" .git)
    local dest_dir="$zsh_custom_dir/$repo_name"

    if [ ! -d "$dest_dir" ]; then
        echo "Cloning '$repo_url' into '$dest_dir'..."
        git clone "$repo_url" "$dest_dir"
    else
        echo "'$repo_name' is already cloned in '$dest_dir'"
    fi
}

REPOS=(
    "https://github.com/zsh-users/zsh-autosuggestions"
    "https://github.com/zsh-users/zsh-syntax-highlighting"
    "https://github.com/zsh-users/zsh-completions"
)

for repo in "${REPOS[@]}"; do
    clone_repo "$repo"
done

# Create symlinks
ln -sf $DOTFILES_DIR/.zshrc ~/.zshrc
ln -sf $DOTFILES_DIR/.p10k.zsh ~/.p10k.zsh
ln -sf $DOTFILES_DIR/.gitconfig ~/.gitconfig

echo "Dotfiles have been symlinked!"

# Install asdf
if [ ! -d "$HOME/.asdf" ]; then
    echo "Installing asdf"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
else
    echo "asdf is already installed"
fi

# Load asdf
. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"

# RUST
if ! asdf plugin-list | grep -q 'rust'; then
    echo "Adding rust plugin to asdf"
    asdf plugin-add rust https://github.com/code-lever/asdf-rust.git
else
    echo "Rust plugin is already added to asdf"
fi

if ! asdf list rust | grep -q "$VERSION"; then
    echo "Installing rust $VERSION"
    asdf install rust $VERSION
else
    echo "Rust $VERSION is already installed via asdf"
fi

asdf global rust $VERSION

# LAZYDOCKER
if ! asdf plugin-list | grep -q 'lazydocker'; then
    asdf plugin add lazydocker https://github.com/comdotlinux/asdf-lazydocker.git
fi

asdf install lazydocker latest
asdf global lazydocker latest

# POWERLEVEL10K
if [ ! -d "$HOME/powerlevel10k" ]; then
    echo "Installing powerlevel10k"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
else
    echo "powerlevel10k is already installed"
fi

# NEOVIM
if ! asdf plugin-list | grep -q 'neovim'; then
    echo "Adding neovim plugin to asdf"
    asdf plugin-add neovim https://github.com/richin13/asdf-neovim.git
else
    echo "neovim plugin already added"
fi

echo "Installing latest neovim..."
asdf install neovim latest
asdf global neovim latest

# NEOVIM
if ! asdf plugin-list | grep -q 'neovim'; then
    echo "Adding neovim plugin to asdf"
    asdf plugin-add neovim https://github.com/richin13/asdf-neovim.git
else
    echo "neovim plugin already added"
fi

echo "Installing latest neovim..."
asdf install neovim latest
asdf global neovim latest

# Neovim config
NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

if [ ! -d "$NVIM_CONFIG_DIR" ]; then
    echo "Cloning your kickstart.nvim config"
    git clone git@github.com:loopsFreitag/kickstart.nvim.git "$NVIM_CONFIG_DIR"
else
    echo "nvim config already exists at $NVIM_CONFIG_DIR"
fi


# JAVA (OpenJDK 17)
if ! asdf plugin-list | grep -q 'java'; then
    echo "Adding java plugin to asdf"
    asdf plugin-add java https://github.com/halcyon/asdf-java.git
else
    echo "java plugin already added"
fi

# Setup Java 17
if ! asdf list java | grep -q 'openjdk-17'; then
    echo "Installing OpenJDK 17"
    asdf install java openjdk-17
else
    echo "OpenJDK 17 is already installed"
fi

asdf global java openjdk-17

echo "All tools have been installed and configured!"
