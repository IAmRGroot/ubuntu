#!/bin/bash

apt update
apt install apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    node-typescript \
    make


# Discord
wget 'https://discord.com/api/download?platform=linux&format=deb' -O discord.deb \
   && dpkg -i discord.deb

# VSCode
wget 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' -O vscode.deb \
   && dpkg -i vscode.deb
   
apt --fix-broken install

# Brave keyring
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list

# Docker keyring
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


apt update

apt install -y \
    flatpak gnome-software-plugin-flatpak \
    brave-browser \
    docker-ce docker-ce-cli containerd.io docker-compose-plugin \
    openfortivpn \
    diodon
    
systemctl disable docker
systemctl stop docker
 

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo \
    && flatpak install flathub com.mattjakeman.ExtensionManager

rm *.deb *.flatpakref

git clone https://github.com/pop-os/shell.git \
    && cd shell \
    && make local-install \
    && cd ..
    && rm -r shell


echo "Install these gnome extensions from the extension manager: 'hide top bar', 'vitals'"
