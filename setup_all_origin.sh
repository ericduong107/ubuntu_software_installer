#!/bin/bash

# ===========================
# Kiểm tra hệ điều hành
# ===========================
# Chỉ hỗ trợ Linux + apt
if [[ "$(uname -s)" != "Linux" ]]; then
    echo "❌ Script này chỉ hỗ trợ Linux."
    exit 1
fi

if ! command -v apt >/dev/null 2>&1; then
    echo "❌ Script này chỉ hỗ trợ các bản phân phối Linux sử dụng apt."
    exit 1
fi

# Hàm kiểm tra gói apt hoặc snap đã cài chưa
is_installed() {
    dpkg -s "$1" >/dev/null 2>&1 || snap list "$1" >/dev/null 2>&1
}

# Hàm dọn dẹp file deb tạm thời ngay sau khi cài
install_deb_url() {
    URL=$1
    FILE_NAME="temp_package.deb"
    echo "⚡ Đang tải gói cài đặt từ: $URL"
    wget -O "$FILE_NAME" "$URL"
    echo "📦 Đang tiến hành cài đặt..."
    sudo apt install "./$FILE_NAME" -y
    echo "🧹 Xóa file cài đặt tạm thời để giải phóng bộ nhớ..."
    rm -f "$FILE_NAME"
}

# TỰ ĐỘNG KIỂM TRA VÀ CÀI WHIPTAIL NẾU HỆ THỐNG CHƯA CÓ
if ! command -v whiptail &> /dev/null; then
    echo "⚙️ Không tìm thấy công cụ tạo giao diện (whiptail). Đang tự động cài đặt qua apt..."
    sudo apt update -y && sudo apt install whiptail -y
fi

# 1. BƯỚC 1: HIỆN GIAO DIỆN RADIO CHỌN NGÔN NGỮ (Chỉ được chọn 1)
LANG_CHOICE=$(whiptail --title "Language Selection / Chọn Ngôn Ngữ" \
    --radiolist "Choose your language / Chọn ngôn ngữ hiển thị:" 15 60 2 \
    "vi" "Tiếng Việt" ON \
    "en" "English" OFF \
    3>&1 1>&2 2>&3)

# Nếu người dùng bấm Cancel
if [ $? -ne 0 ]; then
    echo "❌ Đã hủy bỏ / Cancelled."a
    exit 1
fi

# Xử lý biến ngôn ngữ (Xóa dấu ngoặc kép thừa)
LANG_CHOICE=$(echo "$LANG_CHOICE" | tr -d '"')

# Ngôn ngữ hiển thị
if [ "$LANG_CHOICE" = "vi" ]; then
    TITLE="Trình cài đặt tự động của EricDg"
    TEXT="Bấm [Space] để chọn phần mềm cần cài, sau đó bấm Enter:"
    UP_MSG="🔄 Đang cập nhật hệ thống..."
    CLEAN_MSG="🧹 Đang dọn dẹp hệ thống tối ưu dung lượng..."
    SUCCESS_MSG="🎉 Đã cài đặt hoàn tất các phần mềm được chọn!"
else
    TITLE="EricDg's Auto Installer Suite"
    TEXT="Press [Space] to select software, then press Enter:"
    UP_MSG="🔄 Updating system registries..."
    CLEAN_MSG="🧹 Cleaning up temporary setup files..."
    SUCCESS_MSG="🎉 Selected software installed successfully!"
fi

# 2. BƯỚC 2: CHECKLIST BẢN SẮC CÁC PHẦN MỀM
CHOICES=$(whiptail --title "$TITLE" \
    --checklist "$TEXT" 22 80 14 \
    "chrome" "Google Chrome Browser (.deb)" ON \
    "coccoc" "Cốc Cốc Browser (.deb)" OFF \
    "chromium" "Chromium Browser (apt)" OFF \
    "brave" "Brave Browser (apt repository)" OFF \
    "flatpak" "Hệ thống quản lý gói Flatpak" OFF \
    "github-desktop" "GitHub Desktop Client (.deb)" OFF \
    "vscode" "Visual Studio Code (Official)" OFF \
    "vscodium" "VSCodium (Bản VS Code nguồn mở không tracking)" OFF \
    "sublime-text" "Sublime Text Editor" OFF \
    "notepadplusplus" "Notepad++ (Chạy qua Snap/Wine)" OFF \
    "nvm" "Node Version Manager (NVM)" OFF \
    "nodejs" "NodeJS (Quản lý phiên bản động)" ON \
    "python" "Python Environment (Quản lý phiên bản động)" OFF \
    "flutter" "Flutter SDK (Quản lý phiên bản động)" OFF \
    "android-studio" "Android Studio IDE (Tải qua Tarball)" OFF \
    "warp" "Warp Terminal (.deb)" OFF \
    "teamviewer" "TeamViewer Remote Desktop (.deb)" OFF \
    "telegram" "Telegram Desktop Messenger" OFF \
    "vysor" "Vysor Android Control (.deb)" OFF \
    "htop" "Trình giám sát tài nguyên hệ thống (Nhẹ/Hay)" ON \
    "joplin" "Ứng dụng ghi chú bảo mật Joplin" OFF \
    "atom" "Atom Text Editor (.deb bản lưu trữ)" OFF \
    "docker" "Docker Engine & Compose" OFF \
    "flameshot" "Công cụ chụp ảnh màn hình mạnh mẽ" OFF \
    "gedit" "Trình soạn thảo văn bản mặc định Gnome" OFF \
    "gh" "GitHub CLI Tool" OFF \
    "kvm-qemu" "Hệ thống ảo hóa KVM/QEMU & Libvirt" OFF \
    3>&1 1>&2 2>&3)

# Nếu người dùng bấm Cancel ở bước chọn phần mềm
if [ $? -ne 0 ]; then
    echo "❌ Đã hủy bỏ / Cancelled."
    exit 1
fi

# 3. TIẾN HÀNH CÀI ĐẶT
echo "$UP_MSG"
sudo apt update -y

# Mẹo tăng tốc: Chuyển chuỗi lựa chọn thành mảng để duyệt dễ hơn
SELECTED_APPS=$(echo "$CHOICES" | tr -d '"')

for APP in $SELECTED_APPS; do
    echo "--------------------------------------------------"
    echo "⚙️  Đang xử lý gói: $APP"
    
    case $APP in
        chrome)
            install_deb_url "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
            ;;
        coccoc)
            # Link tải deb chính thức từ máy chủ Cốc Cốc cho Linux
            install_deb_url "https://coccoc.com/download/browser/linux/deb"
            ;;
        chromium)
            sudo apt install chromium-browser -y
            ;;
        brave)
            sudo apt install curl -y
            sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
            sudo apt update && sudo apt install brave-browser -y
            ;;
        flatpak)
            sudo apt install flatpak -y
            ;;
        github-desktop)
            # Bản build linux cộng đồng rất phổ biến ổn định của shiftkey
            RELEASE_URL=$(curl -s https://api.github.com/repos/shiftkey/desktop/releases/latest | grep "browser_download_url.*amd64.deb" | cut -d '"' -f 4)
            install_deb_url "$RELEASE_URL"
            ;;
        vscode)
            install_deb_url "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
            ;;
        vscodium)
            wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/vscodium.gpg > /dev/null
            echo 'deb [ signed-by=/usr/share/keyrings/vscodium.gpg ] https://download.vscodium.com/debs vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list
            sudo apt update && sudo apt install vscodium -y
            ;;
        sublime-text)
            wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/sublimehq.gpg > /dev/null
            echo "deb [signed-by=/usr/share/keyrings/sublimehq.gpg] https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
            sudo apt update && sudo apt install sublime-text -y
            ;;
        notepadplusplus)
            sudo snap install notepad-plus-plus
            ;;
        nvm)
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            ;;
        nodejs)
            # Kiểm tra nếu chưa cài nvm thì ép cài nvm trước để tránh lỗi quản lý phiên bản
            export NVM_DIR="$HOME/.nvm"
            if [ ! -s "$NVM_DIR/nvm.sh" ]; then
                curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
                [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            fi
            
            # Sub-menu chọn phiên bản Node
            NODE_VER_TYPE=$(whiptail --title "NodeJS Version Setup" --menu "Chọn phiên bản NodeJS cài đặt:" 15 60 3 \
                "1" "Cài bản ổn định lâu dài mới nhất (LTS)" \
                "2" "Tự nhập số phiên bản cụ thể (Ví dụ: 18.16.0, 20...)" 3>&1 1>&2 2>&3)
                
            if [ "$NODE_VER_TYPE" = "1" ]; then
                nvm install --lts && nvm use --lts
            elif [ "$NODE_VER_TYPE" = "2" ]; then
                SPECIFIC_NODE=$(whiptail --inputbox "Nhập phiên bản Node chính xác bạn muốn (chỉ số):" 10 50 "20" 3>&1 1>&2 2>&3)
                nvm install "$SPECIFIC_NODE" && nvm use "$SPECIFIC_NODE"
            fi
            ;;
        python)
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
            ;;
        flutter)
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
            # Xuất biến môi trường vào bashrc nếu chưa có
            if ! grep -q "flutter/bin" "$HOME/.bashrc"; then
                echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> "$HOME/.bashrc"
            fi
            cd "$HOME" || exit
            ;;
        android-studio)
            sudo apt install openjdk-17-jdk -y
            # Tải bản Linux sạch
            mkdir -p "$HOME/AndroidStudio" && cd "$HOME/AndroidStudio" || exit
            echo "⚡ Đang tải bản Android Studio chính thức..."
            wget -O android-studio.tar.gz "https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.2.1.24/android-studio-2023.2.1.24-linux.tar.gz"
            tar -xvf android-studio.tar.gz
            rm -f android-studio.tar.gz
            echo "💡 Bạn có thể chạy Android Studio bằng cách truy cập ~/AndroidStudio/android-studio/bin và chạy ./studio.sh"
            cd "$HOME" || exit
            ;;
        warp)
            install_deb_url "https://releases.warp.dev/stable/v0.2024.03.05.08.02.stable_01/warp-terminal_0.2024.03.05.08.02.stable.01_amd64.deb"
            ;;
        teamviewer)
            install_deb_url "https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"
            ;;
        telegram)
            sudo snap install telegram-desktop
            ;;
        vysor)
            # Link deb cộng đồng / chính thức lưu trữ của Linux x64
            install_deb_url "https://vysor.io/download/linux"
            ;;
        htop)
            sudo apt install htop -y
            ;;
        joplin)
            # Cài thông qua Script AppImage chính thức rất an toàn cho Linux
            wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
            ;;
        atom)
            install_deb_url "https://github.com/atom/atom/releases/download/v1.60.0/atom-amd64.deb"
            ;;
        docker)
            sudo apt install ca-certificates curl gnupg lsb-release -y
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
            sudo usermod -aG docker "$USER"
            ;;
        flameshot)
            sudo apt install flameshot -y
            ;;
        gedit)
            sudo apt install gedit -y
            ;;
        gh)
            type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
            sudo mkdir -p -m 755 /etc/apt/keyrings && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/githubcli-archive-keyring.gpg
            sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt update && sudo apt install gh -y
            ;;
        kvm-qemu)
            sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager -y
            sudo adduser "$USER" libvirt
            sudo adduser "$USER" kvm
            ;;
    esac
done

# 4. TỰ ĐỘNG DỌN DẸP HỆ THỐNG
echo "--------------------------------------------------"
echo "$CLEAN_MSG"
sudo apt autoremove -y && sudo apt clean

echo "$SUCCESS_MSG"