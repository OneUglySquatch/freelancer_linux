#!/bin/bash
set -euo pipefail

clear
echo
echo "==============================="
echo " Discovery Freelancer Installer"
echo "==============================="
echo 

#####################################
# CONFIG
#####################################

PREFIX="$HOME/Freelancer"
ISO="$HOME/Downloads/Freelancer.iso"
MOUNT="$HOME/freelancer_cd"
LOGFILE="$HOME/freelancer_install.log"

export WINEPREFIX="$PREFIX"

exec 3>&1
exec >>"$LOGFILE" 2>&1

status() {
    echo >&3
    echo ">>> $1" >&3
    echo >&3
}

info() {
    echo >&3
    echo "$1" >&3
    echo >&3
}

error() {
    echo >&3
    echo "ERROR: $1" >&3
    echo >&3
}

spinner() {
local pid=$1
local msg="$2"
local spin='|/-\'

while kill -0 "$pid" 2>/dev/null; do
    for i in {0..3}; do
        printf "\r>>> %s %c" "$msg" "${spin:$i:1}" >&3
        sleep 0.2
    done
done

wait $pid
rc=$?

if [[ $rc -eq 0 ]]; then
    printf "\r>>> %s [DONE]\n" "$msg" >&3
else
    printf "\r>>> %s [FAILED]\n" "$msg" >&3
fi

return $rc



}

#####################################
# CLEANUP
#####################################

cleanup() {
        info "###################################################################################"
        info "After closing the Freelancer Installer, may need to press Enter to get prompt back."
        echo "To unmount ISO:" >&3
        echo "sudo umount $MOUNT" >&3
        echo >&3
        echo "To remove ISO:" >&3
        echo "sudo rm -rf $MOUNT" >&3
        info "###################################################################################"
}

trap cleanup EXIT

#####################################
# Detect distro
#####################################

if command -v pacman >/dev/null 2>&1; then
DISTRO="arch"

elif command -v dnf >/dev/null 2>&1; then
DISTRO="fedora"

elif command -v apt-get >/dev/null 2>&1; then

if grep -qi ubuntu /etc/os-release; then
    DISTRO="ubuntu"
else
    DISTRO="debian"
fi

else

status "Unsupported Linux distribution."

exit 1
fi

status "Detected distribution: $DISTRO"

case "$DISTRO" in

#####################################
# Arch / EndeavourOS / Manjaro
#####################################

arch)

sudo pacman -S --needed \
    wine \
    winetricks \
    wget \
    curl \
    gnupg \
    ca-certificates \
    >/dev/null 2>&1 &

PID=$!

spinner $PID "Installing required packages"

;;

#####################################
# Fedora
#####################################

fedora)

sudo dnf install -y \
    wine \
    winetricks \
    wget \
    curl \
    gnupg2 \
    ca-certificates \
    >/dev/null 2>&1 &

PID=$!

spinner $PID "Installing required packages"

;;

#####################################
# Ubuntu
#####################################

ubuntu)

sudo dpkg --add-architecture i386

sudo mkdir -pm755 /etc/apt/keyrings

if [[ ! -f /etc/apt/keyrings/winehq.gpg ]]; then
    wget -qO- https://dl.winehq.org/wine-builds/winehq.key | \
        sudo gpg --dearmor -o /etc/apt/keyrings/winehq.gpg
fi

UBUNTU_CODENAME="$(lsb_release -sc)"

WINEHQ_FILE="/etc/apt/sources.list.d/winehq-${UBUNTU_CODENAME}.sources"

if [[ ! -f "$WINEHQ_FILE" ]]; then
    sudo tee "$WINEHQ_FILE" >/dev/null <<EOF

Types: deb
URIs: https://dl.winehq.org/wine-builds/ubuntu
Suites: ${UBUNTU_CODENAME}
Components: main
Signed-By: /etc/apt/keyrings/winehq.gpg
EOF
fi

sudo apt update

sudo apt install -y \
    wget \
    curl \
    gnupg \
    ca-certificates \
    lsb-release \
    winehq-stable \
    winetricks \
    --install-recommends \
    >/dev/null 2>&1 &

PID=$!

spinner $PID "Installing required packages"

;;

#####################################
# Debian
#####################################

debian)

sudo dpkg --add-architecture i386

sudo apt update

sudo apt install -y \
    wget \
    curl \
    gnupg \
    ca-certificates \
    wine \
    wine32 \
    winetricks
    >/dev/null 2>&1 &

PID=$!

spinner $PID "Installing required packages"

;;

esac

#####################################
# Verify Wine
#####################################

if ! command -v wine >/dev/null 2>&1; then

error "Wine was not installed correctly."

exit 1
fi

info "Using: $(wine --version)"

if ! command -v winetricks >/dev/null 2>&1; then
    
    error "Winetricks not found."
    
    exit 1
fi
#####################################
# Removing wine alias's
#####################################

unalias wine 2>/dev/null || true
unalias wineboot 2>/dev/null || true
unalias wineserver 2>/dev/null || true
hash -r

#####################################
# WINE PREFIX
#####################################

if [[ -d "$PREFIX/drive_c" && -f "$PREFIX/system.reg" ]]; then

    info "Existing Wine prefix found:"

    info "$PREFIX"

    info "Reuse it? [y/N]"
    read -rp  REPLY

    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
        rm -rf "$PREFIX"

        status "Creating fresh Wine prefix..."

        mkdir -p "$PREFIX"

        wineboot >/dev/null 2>&1 &
        PID=$!

        spinner $PID "Creating Wine prefix"

        info "Please be patient, this will take a while..."

    else

        info "Reusing existing prefix."

    fi

else

    status "Creating fresh Wine prefix..."

    info "please be patient, this will take a while..."

    mkdir -p "$PREFIX"
    
    wineboot >/dev/null 2>&1 &
PID=$!

spinner $PID "Creating Wine prefix"
   
fi

#####################################
# WINETRICKS COMPONENTS
#####################################

MARKER_FILE="$PREFIX/.freelancer_components_installed"

if [[ ! -f "$MARKER_FILE" ]]; then

    winetricks -q directplay vcrun2005 d3dx9 corefonts >/dev/null 2>&1 &
PID=$!

spinner $PID "Installing DirectX and Runtime Components"
wait $PID

    winetricks dotnet48 >/dev/null 2>&1 &
PID=$!

spinner $PID "Installing .NET Framework 4.8"

    touch "$MARKER_FILE"

fi

#####################################
# PRE-FLIGHT CHECKS
#####################################

if [[ ! -f "$ISO" ]]; then

    error "Freelancer ISO not found:"
    info "$ISO"

    exit 1
fi

#####################################
# MOUNT ISO
#####################################

status "Mounting ISO for installation..."

mkdir -p "$MOUNT"

if mountpoint -q "$MOUNT"; then
    sudo umount "$MOUNT"
fi

sudo mount -o loop "$ISO" "$MOUNT"

info "ISO mounted at:"
info "$MOUNT"

SETUP_EXE="$(find "$MOUNT" -iname "setup.exe" -print -quit)"

if [[ -z "$SETUP_EXE" ]]; then

    error "setup.exe not found in ISO"

    exit 1
fi

#####################################
# INSTALL FREELANCER
#####################################

status "Launching Freelancer installer..."

wine "$SETUP_EXE"
