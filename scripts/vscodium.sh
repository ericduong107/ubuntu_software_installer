#!/bin/bash
echo "⚡ Tiến hành cài đặt VSCodium..."
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/vscodium.gpg > /dev/null
echo 'deb [ signed-by=/usr/share/keyrings/vscodium.gpg ] https://download.vscodium.com/debs vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update && sudo apt install vscodium -y
echo "✓ Hoàn thành cài đặt VSCodium!"