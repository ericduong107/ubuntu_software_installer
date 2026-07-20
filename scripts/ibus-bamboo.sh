#!/bin/bash
echo "⚡ Tiến hành cài đặt Bộ gõ Ibus Bamboo..."
sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo
sudo apt-get update
sudo apt-get install ibus ibus-bamboo --install-recommends
ibus restart
echo "✓ Đã cài đặt xong Bộ gõ Ibus Bamboo"