#!/bin/bash
echo "⚡ Tiến hành cài đặt Cốc Cốc..."
FILE_NAME="temp_coccoc.deb"
wget -O "$FILE_NAME" "https://coccoc.com/download/browser/linux/deb"
sudo apt install "./$FILE_NAME" -y
rm -f "$FILE_NAME"
echo "✓ Đã cài đặt xong Cốc Cốc và dọn dẹp file tạm!"