#!/bin/bash
echo "⚡ Tiến hành cài đặt Visual Studio Code..."
FILE_NAME="temp_vscode.deb"
wget -O "$FILE_NAME" "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
sudo apt install "./$FILE_NAME" -y
rm -f "$FILE_NAME"
echo "✓ Đã cài đặt xong VS Code và dọn dẹp file tạm!"