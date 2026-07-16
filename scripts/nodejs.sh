#!/bin/bash
echo "⚡ Tiến hành cài đặt cấu hình phiên bản NodeJS..."
export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    echo "⚠️ Chưa tìm thấy NVM. Tự động cài đặt NVM trước..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

NODE_VER_TYPE=$(whiptail --title "NodeJS Version Setup" --menu "Chọn phiên bản NodeJS cài đặt:" 15 60 3 \
    "1" "Cài bản ổn định lâu dài mới nhất (LTS)" \
    "2" "Tự nhập số phiên bản cụ thể (Ví dụ: 18.16.0, 20...)" 3>&1 1>&2 2>&3)
    
if [ "$NODE_VER_TYPE" = "1" ]; then
    nvm install --lts && nvm use --lts
elif [ "$NODE_VER_TYPE" = "2" ]; then
    SPECIFIC_NODE=$(whiptail --inputbox "Nhập phiên bản Node chính xác bạn muốn (chỉ số):" 10 50 "20" 3>&1 1>&2 2>&3)
    nvm install "$SPECIFIC_NODE" && nvm use "$SPECIFIC_NODE"
fi
echo "✓ Hoàn thành thiết lập NodeJS!"