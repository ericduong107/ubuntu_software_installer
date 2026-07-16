#!/bin/bash
echo "⚡ Tiến hành cài đặt Google Chrome..."
FILE_NAME="temp_chrome.deb"
wget -O "$FILE_NAME" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
sudo apt install "./$FILE_NAME" -y
rm -f "$FILE_NAME"
echo "✓ Đã cài đặt xong Chrome và dọn dẹp file tạm!"