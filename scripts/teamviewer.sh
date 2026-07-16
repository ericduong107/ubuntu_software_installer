#!/bin/bash
echo "⚡ Tiến hành cài đặt TeamViewer..."
FILE_NAME="temp_teamviewer.deb"
wget -O "$FILE_NAME" "https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"
sudo apt install "./$FILE_NAME" -y
rm -f "$FILE_NAME"
echo "✓ Đã cài đặt xong TeamViewer và dọn dẹp file tạm!"