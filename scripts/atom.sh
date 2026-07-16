#!/bin/bash
echo "⚡ Tiến hành cài đặt Atom Editor bản lưu trữ..."
FILE_NAME="temp_atom.deb"
wget -O "$FILE_NAME" "https://github.com/atom/atom/releases/download/v1.60.0/atom-amd64.deb"
sudo apt install "./$FILE_NAME" -y
rm -f "$FILE_NAME"
echo "✓ Đã cài đặt xong Atom và dọn dẹp file tạm!"