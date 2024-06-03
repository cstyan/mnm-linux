#!/bin/bash
# This will help you install the MMORPG Monsters & Memories on Linux (https://monstersandmemories.com/)
# Made by Wyatt (3930kfc) and Callum (cstyan) from the Monsters & Memories Discord server. (https://discord.com/invite/jvdKKc3CqW)

# 1. Install Steam
ARCH=false
ANSWER=""
echo "Are you using an Arch based Linux distribution? [y/n]"
read ANSWER
if [ "$ANSWER" == "y" ]; then 
    ARCH=true
    echo "Have you updated your /etc/pacman.conf to include the mirrorlist for multilib?"
    read ANSWER
    if [ "$ANSWER" == "y" ]; then 
        sudo pacman -Syu steam # Steam download for Arch & Manjaro Linux
    else
        echo "You must have a mirrorlist config for multilib for steam to be installed properly, see: https://wiki.archlinux.org/title/steam"
        exit 1
    fi
elif [ "$ANSWER" == "n" ]; then
    echo "Are you using an Debian based Linux distribution? [y/n]"
    read ANSWER
    if [ "$ANSWER" == "y" ]; then 
        RED='\033[0;31m'
        NORMAL='\033[0m'
        sudo apt-get update # Sync Repository	
        sudo apt-get install -y flatpak # Download Flatpak
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo # Adding Repository
        sudo flatpak install -y flathub com.valvesoftware.Steam # Steam Download Using Flatpak
        echo -e ${RED}"Steam will not appear on your system until after a reboot."${NORMAL}
        sleep 1
    elif [ "$ANSWER" == "n" ]; then
        echo "Are you using Fedora Linux? [y/n]"
        read ANSWER
        if [ "$ANSWER" == "y" ]; then 
            sudo dnf upgrade --refresh # Software Upgrade
			sudo dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm # Enable Non-Free Repository
            sudo dnf install -y steam # Steam download for Fedora Linux
        fi
    fi
fi

# 2. Download and install Proton GE from it's github repository "https://github.com/GloriousEggroll/proton-ge-custom".
install_proton_source() {
    mkdir "$HOME/.local/share/Steam/" # Make Directory
    mkdir "$HOME/.local/share/Steam/compatibilitytools.d/" # Make Directory
    cd "$HOME/.local/share/Steam/compatibilitytools.d/" # Change Directory
    wget --secure-protocol=TLSv1_3 --retry-connrefused --waitretry=3 https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest -O - | awk -F \" -v RS="," '/browser_download_url/ {print $(NF-1)}' | xargs wget # Download Proton GE 
    tar -zxf "GE-Proton"*".tar.gz" # Unzip GE-Proton
    rm "GE-Proton"*".tar.gz" # Remove Zipfilerm "GE-Proton"*".tar.gz" # Remove Zipfile

    # 3. Download Monsters and Memories
    mkdir $HOME/Games/ # Make Directory
    mkdir $HOME/Games/"Monsters & Memories"/ # Make Directory
    cd $HOME/Games/"Monsters & Memories"/ # Change Directory
    wget --secure-protocol=TLSv1_3 --retry-connrefused --waitretry=3 "https://account.monstersandmemories.com/o2iwokawmedof9/mnmlauncher.zip"
    unzip "mnmlauncher.zip" # Unzip Launcher
	mv "MnMLauncher.exe" "Monsters & Memories.exe" # Renames Exe
    rm "mnmlauncher.zip" # Remove Zipfile
}

if [ "$ARCH" = true]; then
    echo "Would you like to install the proton AUR package rather than installing proton from source?"
    read ANSWER
    if [ "$ANSWER" == "y" ]; then 
        echo "installing via pacman"
        pacman -S proton
    else
        install_proton_source
    fi
else 
   install_proton_source
fi

# 4. Login to Steam and Select Proton-GE for Monsters & Memories
steam & # Starts Steam in the background
RED='\033[0;31m'
GREEN='\033[0;32m' 
BLUE='\033[0;34m'
NORMAL='\033[0m'
echo -e "\n"
echo -e ${BLUE}'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'${NORMAL}
echo -e ${GREEN}'Please login to '${RED}'Steam'${GREEN}' and click the top '${RED}'"Games"'${GREEN}' tab'."\n"
echo -e 'From there click '${RED}'"Add a Non-Steam Game to My Library"'${GREEN}' and naviagte to the download location of '${RED}'"Monsters & Memories.exe"'${GREEN}' to add it. Once added go to the '${RED}'"Library"'${GREEN}' tab and right click the game and select '${RED}'"Properties"'${GREEN}'.'"\n"
echo -e 'Next go to '${RED}'"Compatibility"'${GREEN}' and click the '${RED}'"Force the use of a specific Steam Play compatibility tool"'${GREEN}' box. From there Select a Proton version that starts with '${RED}'"GE"'${GREEN}'. It should look similar to this, '${RED}'"GE-Proton9-5"'${GREEN}'.'
echo -e ${BLUE}'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'${NORMAL}
