#!/bin/bash
echo "⚡ Tiến hành cài đặt Android Studio..."
sudo apt install openjdk-17-jdk -y
mkdir -p "$HOME/AndroidStudio" && cd "$HOME/AndroidStudio" || exit
FILE_NAME="android-studio.tar.gz"
wget -O "$FILE_NAME" "https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.2.1.24/android-studio-2023.2.1.24-linux.tar.gz"
tar -xvf "$FILE_NAME"
rm -f "$FILE_NAME"
echo "💡 Để chạy Android Studio: ~/AndroidStudio/android-studio/bin/studio.sh"
cd "$HOME" || exit