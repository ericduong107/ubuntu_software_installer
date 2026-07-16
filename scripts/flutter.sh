#!/bin/bash
echo "⚡ Tiến hành cài đặt Flutter SDK..."
FLUTTER_VER_TYPE=$(whiptail --title "Flutter SDK Setup" --menu "Chọn kênh/phiên bản cài đặt Flutter:" 15 60 3 \
    "1" "Cài kênh ổn định mặc định (Stable Channel)" \
    "2" "Tự nhập phiên bản Flutter cụ thể (Ví dụ: 3.19.0)" 3>&1 1>&2 2>&3)
    
sudo apt install git curl unzip xz-utils zip libglu1-mesa -y
mkdir -p "$HOME/development"
cd "$HOME/development" || exit

if [ "$FLUTTER_VER_TYPE" = "1" ]; then
    git clone https://github.com/flutter/flutter.git -b stable
elif [ "$FLUTTER_VER_TYPE" = "2" ]; then
    SPECIFIC_FLUTTER=$(whiptail --inputbox "Nhập mã phiên bản Flutter cụ thể:" 10 50 "3.19.0" 3>&1 1>&2 2>&3)
    git clone https://github.com/flutter/flutter.git
    cd flutter && git checkout "$SPECIFIC_FLUTTER" && cd ..
fi

if ! grep -q "flutter/bin" "$HOME/.bashrc"; then
    echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> "$HOME/.bashrc"
fi
cd "$HOME" || exit
echo "✓ Hoàn thành thiết lập Flutter SDK!"