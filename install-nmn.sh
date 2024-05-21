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
        sudo pacman -Syu steam # Download Steam for Arch & Manjaro Linux
    else
        echo "You must have a mirrorlist config for multilib for steam to be installed properly, see: https://wiki.archlinux.org/title/steam"
        exit 1
    fi
elif [ "$ANSWER" == "n" ]; then
    echo "Are you using an Debian based Linux distribution? [y/n]"
    read ANSWER
    if [ "$ANSWER" == "y" ]; then 
        sudo apt-get update
        sudo apt-get install -y steam # Download Steam for Debian, Ubuntu, and Mint Linux
    elif [ "$ANSWER" == "n" ]; then
        echo "Are you using a Fedora based Linux distribution? [y/n]"
        read ANSWER
        if [ "$ANSWER" == "y" ]; then 
            sudo dnf install -y steam # Download Steam for Fedora Linux
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
    wget --secure-protocol=TLSv1_3 --retry-connrefused --waitretry=3 "https://account.monstersandmemories.com/*/mnmlauncher.zip"
    unzip "mnmlauncher.zip" # Unzip Launcher
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
echo -e "\n"'Please login to Steam and click the top "Games" tab. From there click "Add a Non-Steam Game to My Library" and naviagte to the download location of mnmlauncher.exe. Once added go to the Library tab and right click the game and select properties. 

From there go to "Compatibility" and check the "Force the use of a specofoc Steam Play compatibility tools" box. From there Select the Proton version that starts with "GE". It should look something like "GE-Proton9-5".'