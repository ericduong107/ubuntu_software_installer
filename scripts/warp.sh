#!/bin/bash
echo "⚡ Tiến hành cài đặt Warp Terminal..."
FILE_NAME="temp_warp.deb"
wget -O "$FILE_NAME" "https://releases.warp.dev/stable/v0.2024.03.05.08.02.stable_01/warp-terminal_0.2024.03.05.08.02.stable.01_amd64.deb"
sudo apt install "./$FILE_NAME" -y
rm -f "$FILE_NAME"
echo "✓ Đã cài đặt xong Warp Terminal và dọn dẹp file tạm!"