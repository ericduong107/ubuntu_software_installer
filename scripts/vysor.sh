#!/bin/bash
echo "⚡ Tiến hành cài đặt Vysor..."
FILE_NAME="temp_vysor.deb"
wget -O "$FILE_NAME" "https://vysor.io/download/linux"
sudo apt install "./$FILE_NAME" -y
rm -f "$FILE_NAME"
echo "✓ Đã cài đặt xong Vysor và dọn dẹp file tạm!"