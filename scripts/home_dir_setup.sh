#!/usr/bin/env bash

#set -xv
set -euo pipefail

#############################################################################
#                                                                           #
# Name: home_dir_setup.sh                                                   #
# Path: N/A                                                                 #
# Host(s): N/A                                                              #
# Info: Automated Setup Script to setup a home directory for a power user   #
#                                                                           #
# Modification date: DD/MM/YYYY                                             #
# Modified by: XXXXXX                                                       #
# Modifications:                                                            #
# - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                          #
#                                                                           #
#############################################################################

#############################################################################
# Logging Framework                                                         #
#############################################################################

SCRIPT_NAME="${0%.*}"
LOG_FILE="$(pwd)/${SCRIPT_NAME}.log"
: > "$LOG_FILE"

# Redirect stdout and stderr to log file, but keep FD 3 for console output
exec 3>&1 1>>"$LOG_FILE" 2>&1

# Not reinventing the wheel. From the following link:
# https://www.ludovicocaldara.net/dba/bash-tips-4-use-logging-levels/
colblk='\033[0;30m' # Black - Regular
colred='\033[0;31m' # Red
colgrn='\033[0;32m' # Green
colylw='\033[0;33m' # Yellow
colpur='\033[0;35m' # Purple
colrst='\033[0m'    # Text Reset
colwht='\033[0;37m' # White

verbosity=5

### verbosity levels
silent_lvl=0
crt_lvl=1
err_lvl=2
wrn_lvl=3
ntf_lvl=4
inf_lvl=5
dbg_lvl=6

## esilent prints output even in silent mode
function esilent {
    verb_lvl=$silent_lvl elog "$*"
}

function enotify {
    verb_lvl=$ntf_lvl elog "$*"
}

function eok {
    verb_lvl=$ntf_lvl elog "SUCCESS - $*"
}

function ewarn {
    verb_lvl=$wrn_lvl elog "${colylw}WARNING${colrst} - $*"
}

function einfo {
    verb_lvl=$inf_lvl elog "${colwht}INFO${colrst} ---- $*"
}

function edebug {
    verb_lvl=$dbg_lvl elog "${colgrn}DEBUG${colrst} --- $*"
}

function eerror {
    verb_lvl=$err_lvl elog "${colred}ERROR${colrst} --- $*"
}

function ecrit {
    verb_lvl=$crt_lvl elog "${colpur}FATAL${colrst} --- $*"
}

function edumpvar {
    for var in "$@"; do
        edebug "$var=${!var}"
    done
}

function elog {
    datestring=$(date +"%Y-%m-%d %H:%M:%S")
    if [[ $verbosity -lt $verb_lvl ]]; then
        #echo -e "${datestring} - $*" >> "$LOG_FILE" 2>&1
        echo -e "${datestring} - $*" >&3
    else
        #echo -e "${datestring} - $*" 2>&1 | tee -a "$LOG_FILE"
        echo -e "${datestring} - $*" >&3
        #echo -e "${datestring} - $*" >&3 | exec 3>&1 1>> "$LOG_FILE" 2>&1
    fi
}

trap 'eerror "Script failed at line $LINENO"' ERR

#############################################################################
# Environment variables                                                     #
#############################################################################

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:${HOME}/bin
#PATH=${ASDF_DATA_DIR:-$HOME/.asdf}/shims:${ASDF_DATA_DIR:-$HOME/.asdf}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:${HOME}/bin
export PATH
echo $PATH
source /etc/os-release
DISTRO="${ID:-unknown}"
DISTRO_NAME="${PRETTY_NAME:-unknown}"
IS_WSL=false
HOST=$(hostname)
DATE=$(date +"%Y%m%d")
TIME=$(date +"%H%M%S")

#LOCAL_INSTALL_DIR="$HOME/.local/bin"
LOCAL_INSTALL_DIR="/usr/local/bin"
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

ASDF_DIR="$HOME/.asdf"
ASDF_LANGUAGES=(
    golang
    nodejs
    python
    rust
)
#export PERL_USE_UNSAFE_INC=1

PACKAGES_UBUNTU=(
    allacritty
    bat
    build-essential
    curl 
    dirmngr 
    eza
    fd-find
    fontconfig
    gcc
    git 
    git-extras
    gh
    gpg 
    httpie
    libbz2-dev 
    libffi-dev 
    liblzma-dev 
    libncursesw5-dev 
    libreadline-dev 
    libsqlite3-dev 
    libssl-dev 
    libxml2-dev 
    libxmlsec1-dev 
    linux-headers-$(uname -r)
    m4
    make
    ranger
    ripgrep
    screen
    stow
    terminator
    tk-dev 
    tmux
    unzip
    util-linux
    vim
    wget
    xz-utils 
    zlib1g-dev 
    zoxide
    zsh
)
PACKAGES_WSL=(
    bat
    build-essential
    curl 
    dirmngr 
    eza
    fd-find
    fontconfig
    gcc
    git 
    git-extras
    gh
    gpg 
    libbz2-dev 
    libffi-dev 
    liblzma-dev 
    libncursesw5-dev 
    libreadline-dev 
    libsqlite3-dev 
    libssl-dev 
    libxml2-dev 
    libxmlsec1-dev 
    m4
    make
    ranger
    ripgrep
    screen
    stow
    tmux
    unzip
    util-linux
    vim
    wget
    xz-utils 
    zlib1g-dev 
    zoxide
    zsh
)
PACKAGES_RHEL=(
    allacritty
    bat
    bzip2-devel
    curl 
    dirmngr 
    eza
    fd-find
    fontconfig
    fzf
    gcc
    gcc-c++
    git 
    git-extras
    gh
    gnupg2 
    httpie
    kitty
    lazygit
    libffi-dev 
    xz-devel
    ncurses-devel
    readline-devel
    sqlite-devel
    openssl-devel
    libxml2-devel
    xmlsec1-devel
    kernel-devel
    kernel-headers
    m4
    make
    neovim
    ranger
    ripgrep
    screen
    stow
    terminator
    tk-devel 
    tmux
    unzip
    vim
    wget
    xz
    zlib-devel
    zoxide
    zsh
)
PACKAGES_ARCH=(
    allacritty
    base-devel
    bat
    bzip2
    curl 
    dirmngr 
    eza
    fd-find
    fontconfig
    fzf
    gcc
    git 
    git-extras
    github-cli
    gh
    gnupg 
    httpie
    kitty
    lazygit
    libffi
    libxml2
    linux-headers
    m4
    make
    ncurses
    neovim
    openssl
    ranger
    readline
    ripgrep
    screen
    sqlite
    stow
    terminator
    tk-dev 
    tmux
    unzip
    vim
    wget
    xmlsec
    xz
    zlib
    zoxide
    zsh
)

NERD_FONTS=(
    Hack
    JetBrainsMono
    FiraCode
    Meslo
)
FONT_DIR="$HOME/.local/share/fonts"

#############################################################################
# Function definitions                                                      #
#############################################################################

#----------------------------------------------------------------------------
# Function: usage
#
# Arguments:
# - N/A
#
# Retun:
# - N/A

function usage {

    cat <<EOF
    Usage: $0 [--help|-h]
        --help|-h: This help
EOF

}

function clean_up {

    einfo "Cleaning up .oh-my-zsh and dotfiles..."
    cd $HOME
    rm -rf .oh-my-zsh dotfiles .asdf .tool-versions .zshrc .local/share/nvim .config/nvim .fzf

}

# Map standard uname output to asdf release naming convention
function check_platform {

    case "$ARCH" in
        x86_64) ARCH="amd64" ;;
        aarch64) ARCH="arm64" ;;
        *) 
            eerror "Unsupported architecture: $ARCH"
            exit 1 
            ;;
    esac

    # Normalize OS names (mainly for macOS)
    if [[ "$OS" == "linux" ]]; then
        OS="linux"
    else
        eerror "Unsupported OS: $OS"
        exit 1
    fi

    uname -r | grep -qi microsoft
    RC=$?
    if (( $RC == 0 ))
    then
        IS_WSL=true
    fi

    einfo "Detected: $OS / $ARCH"

}

# Configure EPEL repo for RHEL
function configure_epel_repo {

    dnf repolist | grep -q "^epel"
    RC=$?
    if (( $RC != 0 ))
    then
        case ${VERSION_ID%%.*} in
            10|9 )
                case $DISTRO in
                    fedora )
                        sudo dnf config-manager --set-enabled crb
                        sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-${VERSION%%.*}.noarch.rpm
                        ;;
                    rhel )
                        sudo subscription-manager repos --enable codeready-builder-for-rhel-${VERSION_ID%%.*}-${ARCH}-rpms
                        sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-${VERSION_ID%%.*}-noarch.rpm
                        ;;
                    * )
                        eerror "Wrong distro!!!"
                        exit 1
                        ;;
                esac
                ;;
            8 )
                case $DISTRO in
                    fedora )
                        sudo dnf config-manager --set-enabled powertools
                        sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-${VERSION_ID%%.*}.noarch.rpm
                        ;;
                    rhel )
                        sudo subscription-manager repos --enable codeready-builder-for-rhel-${VERSION_ID%%.*}-$(arch)-rpms
                        sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-${VERSION_ID%%.*}.noarch.rpm
                        ;;
                    * )
                        eerror "Wrong distro!!!"
                        exit 1
                        ;;
                esac
                ;;
        esac
    fi

}

function fix_batcat {

    if command -v batcat >/dev/null && ! command -v bat >/dev/null; then
        einfo "Creating symlink from batcat to bat..."
        sudo ln -sf "$(command -v batcat)" /usr/local/bin/bat
    fi

}

function setup_lazygit {

    if command -v lazygit >/dev/null
    then
        einfo "lazygit already installed"
        return
    fi

    einfo "Installing lazygit from GitHub release..."

    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
    rm -rf lazygit.tar.gz lazygit

}

# Common development tools and utilities
function install_packages {

    # Update package list
    #sudo apt update -y

    einfo "Installing requested packages..."
    if [[ IS_WSL == "false" ]]
    then
        case $DISTRO in
            ubuntu|debian|kali|linuxmint )
                einfo "Using apt package manager..."
                # Alacritty: add PPA for latest version (recommended over building from source)
                sudo add-apt-repository ppa:aslatter/ppa -y
                # GitHub CLI
                sudo mkdir -p -m 755 /etc/apt/keyrings \
                && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
                && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
                && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null 
                # A modern, maintained replacement for ls, written in rust
                wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg \
                && echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list \
                && sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list 
                # Installing all packages
                sudo apt update
                sudo apt install -y "${PACKAGES_UBUNTU[@]}"
                # Install neovim 0.10 or higher
                sudo apt remove -y neovim
                sudo snap install nvim --classic
                # Install latest fzf
                sudo apt remove -y fzf
                git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
                # Kitty: official curl installer (places in ~/.local/kitty.app)
                curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
                # Fix batcat alias for Ubuntu
                fix_batcat
                # Setup lazygit
                setup_lazygit
                ;;
            fedora|rhel|centos )
                einfo "Using dnf package manager..."
                configure_epel_repo
                sudo dnf install -y "${PACKAGES_RHEL[@]}"
                ;;
            arch|manjaro )
                einfo "Using pacman package manager..."
                sudo pacman -Syu --noconfirm "${PACKAGES_ARCH[@]}"
                ;;
            * )
                eerror "Unsupported distribution: $DISTRO - ${PRETTY_NAME}"
                exit 1
                ;;
        esac
    else
        einfo "Using apt package manager..."
        if [[ ! -d /etc/apt/keyrings ]]
        then
            sudo mkdir -p -m 755 /etc/apt/keyrings 
        fi
        # GitHub CLI
        wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
        && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null 
        # A modern, maintained replacement for ls, written in rust
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/gierens.gpg \
        && echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list \
        && sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list 
        # Installing all packages
        sudo apt update
        sudo apt install -y "${PACKAGES_WSL[@]}"
        # Install neovim 0.10 or higher
        sudo apt remove -y neovim
        sudo snap install nvim --classic
        # Install latest fzf
        sudo apt remove -y fzf
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        # Fix batcat alias for Ubuntu
        fix_batcat
        # Setup lazygit
        setup_lazygit
    fi

}

# Nerd Fonts: install popular ones (Hack and JetBrainsMono are common for terminals)
function install_nerd_fonts {

    einfo "Installing Nerd Fonts..."
    for i in "${NERD_FONTS[@]}"
    do
        einfo "- $i"
    done
    if [[ ! -d ${FONT_DIR} ]]
    then
        mkdir -p -m 755 ${FONT_DIR}
    fi
    cd ${FONT_DIR}

    NERD_FONTS_VERSION=$(curl -s "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
    for NERD_FONT in "${NERD_FONTS[@]}"
    do
        curl -fLO "https://github.com/ryanoasis/nerd-fonts/releases/download/v${NERD_FONTS_VERSION}/${NERD_FONT}.zip"
        unzip -o "${NERD_FONT}.zip"
        rm "${NERD_FONT}.zip"
    done

    if [[ $IS_WSL == "false" ]]
    then
        fc-cache -fv
    fi
    cd ~

}

# Clone dotfiles
function clone_dotfiles {

    einfo "Cloning dotfiles..."
    gh auth status
    RC=$?
    if (( $RC != 0 ))
    then
        gh auth login
    fi
    gh repo clone https://github.com/nobre165/dotfiles.git ~/dotfiles

    # If the repo uses stow, you can stow packages later manually, e.g.:
    # cd ~/dotfiles
    # stow zsh
    # stow nvim
    # etc.
    #einfo "Dotfiles cloned to ~/dotfiles. If they use stow, run 'stow <package>' inside that directory."
    #cd ~/dotfiles
    #stow .

}

# Install Oh My Zsh
function install_oh-my-zsh {

    einfo "Installing Oh My Zsh..."
    #sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --skip-chsh
    #sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --skip-chsh --keep-zshrc
    #sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh; exit)"

    ZSH_CUSTOM="$HOME/.oh-my-zsh"
    # Installing autosuggestions plugin
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    # Installing zsh-syntax-highlighting plugin
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    # Installing zsh-fast-syntax-highlighting plugin
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
    # Installing zsh-autocomplete plugin
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete

}

# Install Starship prompt
function install_starship {

    einfo "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    #curl -sS https://starship.rs/install.sh | sh

}

# Install asdf languages
function install_asdf_language {

    local lang="$1"
    einfo "Installing language $lang..."

    if ${LOCAL_INSTALL_DIR}/asdf plugin list | grep -q "$lang"
    then
        einfo "Plugin $lang already installed."
    else
        einfo "Adding plugin $lang..."
        ${LOCAL_INSTALL_DIR}/asdf plugin add "$lang"
    fi

    ${LOCAL_INSTALL_DIR}/asdf install "$lang" latest
    ${LOCAL_INSTALL_DIR}/asdf set -u "$lang" latest
    einfo "$lang $(${LOCAL_INSTALL_DIR}/asdf current "$lang") installed."

}

# Install asdf
function setup_asdf {

    einfo "Setting up asdf with nodejs, python, rust, and golang..."
    # reliable way to get the tag_name from the latest release JSON
    ASDF_LATEST_VERSION=$(curl -s https://api.github.com/repos/asdf-vm/asdf/releases/latest \
                            | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    if [[ -d "$ASDF_DIR" ]]
    then
        einfo "ASDF directory already exists. Cleaning up..."
        rm -rf "$ASDF_DIR"
        #mkdir -p "${ASDF_DIR}"/{plugin,installs,shims,downloads,tmp}

        # Initial reshim (creates shim executables)
        ${LOCAL_INSTALL_DIR}/asdf reshim
    fi

    ASDF_BIN_FILE="asdf-${ASDF_LATEST_VERSION}-${OS}-${ARCH}.tar.gz"
    ASDF_DOWNLOAD_URL="https://github.com/asdf-vm/asdf/releases/download/${ASDF_LATEST_VERSION}/${ASDF_BIN_FILE}"

    cd /tmp
    if curl -LO "${ASDF_DOWNLOAD_URL}"
    then
        tar -zxf "${ASDF_BIN_FILE}" 
        sudo mv asdf "${LOCAL_INSTALL_DIR}" 
        sudo chmod +x "${LOCAL_INSTALL_DIR}/asdf"
        sudo rm "${ASDF_BIN_FILE}"
        einfo "ASDF binary installed to $LOCAL_INSTALL_DIR"
    else
        eerror "Couldn't download asdf!!!"
        exit 1
    fi
    git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR" --branch "$ASDF_LATEST_VERSION"

    # Source asdf for the current script session
    if [[ -f "$ASDF_DIR/asdf.sh" ]]; then
        source "$ASDF_DIR/asdf.sh"
    else
        eerror "Failed to source asdf.sh at $ASDF_DIR/asdf.sh"
        exit 1
    fi

    for i in "${ASDF_LANGUAGES[@]}"
    do
        install_asdf_language "$i"
    done

}

# Using settings from dotfiles
function setup_dotfiles {

    einfo "Setting up dotfiles..."

    # Setting up bash profile
    einfo "Setting up dotfiles bash..."
    cd
    rm -rf .bash_logout .bash_profile .bashrc .fzf.bash
    cd ~/dotfiles
    stow bash

    # Setting up ksh
    einfo "Setting up dotfiles ksh..."
    cd
    rm -rf .profile
    cd ~/dotfiles
    stow ksh

    # Setting up zsh
    einfo "Setting up dotfiles zsh..."
    cd
    rm -rf .fzf.zsh .zprofile .zsh_aliases .zshenv .zshrc .zsh_oh-my-zsh .zshrc_starship
    cd ~/dotfiles
    stow zsh
    $HOME/.fzf/install --key-bindings --completion --no-update-rc

    # Setting up fonts
    # Setting up git
    einfo "Setting up dotfiles git..."
    cd
    rm -rf .gitconfig .gitconfig-personal .gitconfig-ibm
    cd ~/dotfiles
    stow git
    git config --global --replace-all user.name "Anderson Nobre"
    git config --global --replace-all user.email "nobre165@gmail.com"
    git remote set-url origin git@github.com:nobre165/dotfiles.git


    # Setting up vim
    einfo "Setting up dotfiles vim..."
    cd
    rm -rf .vim .vimrc
    cd ~/dotfiles
    stow vim

    # Setting up nvim
    einfo "Setting up dotfiles nvim..."
    cd ~/.config
    rm -rf nvim*
    cd ~/dotfiles
    stow nvim

    # Setting up screen
    einfo "Setting up dotfiles screen..."
    cd
    rm -rf .screenrc
    cd ~/dotfiles
    stow screen

    # Setting up tmux
    einfo "Setting up dotfiles tmxu..."
    cd
    rm -rf .tmux.conf
    cd ~/dotfiles
    stow tmux

    # Setting up ssh
    einfo "Setting up dotfiles ssh_config..."
    cd
    rm -rf ~/.ssh/config
    cd ~/dotfiles
    stow ssh

    # Setting up oh-my-zsh
    #einfo "Setting up dotfiles oh-my-zsh..."
    #cd
    #rm -rf ~/.oh-my-zsh/oh-my-zsh.sh
    #cd ~/dotfiles
    #stow oh-my-zsh

    # Setting up startship
    einfo "Setting up dotfiles starship..."
    cd
    rm -rf ~/.config/starship*
    cd ~/dotfiles
    stow starship

    if [[ IS_WSL == "false" ]]
    then
        # Setting up alacritty
        einfo "Setting up dotfiles alacritty..."
        cd
        rm -rf ~/.config/alacritty/*.toml
        cd ~/dotfiles
        stow alacritty

        # Setting up kitty
        einfo "Setting up dotfiles kitty..."
        cd
        rm -rf ~/.config/kitty/*.conf
        cd ~/dotfiles
        stow kitty

        # Setting up terminator
        einfo "Setting up dotfiles terminator..."
        cd
        rm -rf ~/.config/terminator/config*
        stow terminator
    fi

}

# Optional: set Zsh as default shell (requires logout/relogin)
function set_zsh {

    einfo "Changing user shell to zsh..."
    sudo chsh -s $(which zsh)

}


#############################################################################
# Script main logic                                                         #
#############################################################################

#############################################################################
# Argument Parsing (Refactored using getopt)                                #
#############################################################################

# --- Define options for getopt ---
# Short options: h, e: (e requires an argument)
# Long options: help, exclude-nodes: (requires argument), output-dir: (requires argument)
SHORT_OPTS="h"
LONG_OPTS="help"

# --- Check for getopt availability ---
if ! command -v getopt > /dev/null; then
    eerror "getopt command is required for argument parsing but not found."
    exit 1
fi

# --- Parse arguments using getopt ---
# The '--' ensures that getopt processing stops if it encounters '--' in the arguments.
# "$@" passes the original script arguments correctly, preserving spaces within arguments.
PARSED_OPTIONS=$(getopt --options "$SHORT_OPTS" --longoptions "$LONG_OPTS" --name "$0" -- "$@")
GETOPT_RC="$?"

if [[ $GETOPT_RC -ne 0 ]]; then
    # getopt reports errors to stderr, so we just show usage and exit.
    ewarn "Argument parsing error (see stderr output from getopt)." # Use ewarn or eerror
    usage # Call existing usage function
    exit 1
fi

# --- Replace script's arguments with parsed & sanitized arguments ---
# This eval is considered safe because PARSED_OPTIONS is output from getopt
# and is specifically formatted and quoted for this purpose.
eval set -- "$PARSED_OPTIONS"

# --- Process the parsed options ---
DIAG_FLAG="0"
einfo "Processing command-line arguments..." # Optional logging
while true; do
    case "$1" in
        -h | --help)
            usage
            exit 0
            ;;
        --) # End of options marker from getopt
            shift # Consume the '--'
            break # Exit the loop
            ;;
        *)
            # This should not happen if getopt works correctly
            eerror "Internal argument parsing error! Unexpected option: $1"
            usage
            exit 1
            ;;
    esac
done

# --- Handle remaining positional arguments ---
# This script doesn't expect positional arguments, so error if any are left.
if [[ "$#" -gt 0 ]]; then
    eerror "Unexpected positional arguments found: $*" >&2
    usage
    exit 1
fi

# --- Proceed with script logic ---
einfo "Starting home directory setup..."
clean_up
check_platform
install_packages
install_nerd_fonts
clone_dotfiles
install_oh-my-zsh
install_starship
setup_asdf
setup_dotfiles
set_zsh

einfo "Setup complete!"
einfo "Recommendations:"
einfo "- Reboot or log out/in for font cache and shell changes."
einfo "- Configure your terminal (Alacritty/Kitty/Terminator) to use a Nerd Font (e.g., Hack Nerd Font or JetBrainsMono Nerd Font)."
einfo "- If using WSL, some GUI terminals like Alacritty/Kitty may need X server setup (e.g., VcXsrv)."
einfo "- Apply dotfiles as per the repo's README (likely using stow)."