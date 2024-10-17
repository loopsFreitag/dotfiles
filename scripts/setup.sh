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
ln -s $DOTFILES_DIR/lvim/ ~/.config/lvim
ln -sf $DOTFILES_DIR/polybar ~/.config/polybar
ln -sf $DOTFILES_DIR/.gitconfig ~/.gitconfig

echo "Dotfiles have been symlinked!"

# Install asdf
if [ ! -d "$HOME/.asdf" ]; then
    echo "Installing asdf"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
else
    echo "asdf is already installed"
fi

# Adding rust
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

# Adding lazydocker
asdf plugin add lazydocker https://github.com/comdotlinux/asdf-lazydocker.git

asdf install lazydocker latest

asdf global lazydocker latest

# Dependencies for lvim
if [ "$PKG_MANAGER" = "pacman" ]; then
    echo "Installing base-devel"
    sudo pacman -S --noconfirm base-devel
elif [ "$PKG_MANAGER" = "apt" ]; then
    echo "Installing build-essential"
    sudo apt install -y build-essential
fi

# Installing nvim
if ! command -v nvim > /dev/null; then
    echo "Installing Neovim"
    if [ "$PKG_MANAGER" = "apt" ]; then
      sudo add-apt-repository -y ppa:neovim-ppa/unstable
      sudo apt update
      sudo apt install -y neovim
    elif [ "$PKG_MANAGER" = "pacman" ]; then
        sudo pacman -S --noconfirm neovim
    fi
else
    echo "Neovim is already installed"
fi

# Installing lvim
if [ ! -d "$HOME/.local/share/lunarvim" ]; then
    echo "Installing LunarVim"
    if [ "$VERSION" = "stable" ]; then
        LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh)
    elif [ "$VERSION" = "nightly" ]; then
        bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
    fi
else
    echo "LunarVim is already installed"
fi

# Installing p10k
if [ ! -d "$HOME/powerlevel10k" ]; then
    echo "Installing powerlevel10k"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
else
    echo "powerlevel10k is already installed"
fi
