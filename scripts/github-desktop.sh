#!/bin/bash
echo "⚡ Tiến hành cài đặt GitHub Desktop..."
RELEASE_URL=$(curl -s https://api.github.com/repos/shiftkey/desktop/releases/latest | grep "browser_download_url.*amd64.deb" | cut -d '"' -f 4)
FILE_NAME="temp_github_desktop.deb"
wget -O "$FILE_NAME" "$RELEASE_URL"
sudo apt install "./$FILE_NAME" -y
rm -f "$FILE_NAME"
echo "✓ Đã cài đặt xong GitHub Desktop và dọn dẹp file tạm!"