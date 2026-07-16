#!/bin/bash
echo "⚡ Tiến hành cấu hình môi trường Python..."
PY_VER_TYPE=$(whiptail --title "Python Version Setup" --menu "Chọn cấu hình phiên bản Python:" 15 60 3 \
    "1" "Cài bản ổn định mặc định theo Ubuntu 20 (Thường là Python 3.8)" \
    "2" "Cài bản cụ thể thông qua kho deadsnakes PPA" 3>&1 1>&2 2>&3)
    
if [ "$PY_VER_TYPE" = "1" ]; then
    sudo apt install python3 python3-pip python3-venv -y
elif [ "$PY_VER_TYPE" = "2" ]; then
    SPECIFIC_PY=$(whiptail --inputbox "Nhập phiên bản Python cụ thể (Ví dụ: 3.10, 3.11):" 10 50 "3.10" 3>&1 1>&2 2>&3)
    sudo apt install software-properties-common -y
    sudo add-apt-repository ppa:deadsnakes/ppa -y
    sudo apt update
    sudo apt install "python$SPECIFIC_PY" "python$SPECIFIC_PY-venv" -y
fi
echo "✓ Hoàn thành cấu hình Python!"