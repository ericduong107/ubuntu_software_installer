#!/bin/bash

# ==============================================================================
# Script Name   : auto_installer.sh
# Description   : Trình cài đặt tự động nâng cao tích hợp qua GitHub
# Author        : EricDg (Updated by Gemini)
# Platform      : Linux (Ubuntu/Debian based with apt)
# ==============================================================================

# ===========================
# Kiểm tra hệ điều hành & Quyền hạn
# ===========================
if [[ "$(uname -s)" != "Linux" ]]; then
    echo "❌ This script only supports Linux. / ❌ Script này chỉ hỗ trợ Linux."
    exit 1
fi

if ! command -v apt >/dev/null 2>&1; then
    echo "❌ This script only supports Linux distributions that use apt. / ❌ Script này chỉ hỗ trợ các bản phân phối Linux sử dụng apt."
    exit 1
fi

# Tự động kiểm tra và cài whiptail nếu hệ thống chưa có
if ! command -v whiptail &> /dev/null; then
    echo "⚙️ The widget builder (whiptail) was not found. It is being automatically installed via apt... / ⚙️ Không tìm thấy công cụ tạo giao diện (whiptail). Đang tự động cài đặt qua apt..."
    sudo apt update -y && sudo apt install whiptail -y
fi

# ===========================
# Cấu hình GitHub Repository
# ===========================
# 💡 BẠN HÃY ĐỔI 3 BIẾN NÀY CHO ĐÚNG THÔNG TIN REPO CỦA BẠN:
GITHUB_USER="ericduong107"
REPO_NAME="ubuntu_software_installer"
BRANCH="main"
REPO_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${REPO_NAME}/${BRANCH}/scripts"

# ===========================
# Bước 1: Chọn Ngôn Ngữ (Radio List)
# ===========================
LANG_CHOICE=$(whiptail --title "Language Selection / Chọn Ngôn Ngữ" \
    --radiolist "Choose your language / Chọn ngôn ngữ hiển thị:" 15 60 2 \
    "vi" "Tiếng Việt" ON \
    "en" "English" OFF \
    3>&1 1>&2 2>&3)

# Nếu người dùng bấm Cancel
if [ $? -ne 0 ] || [ -z "$LANG_CHOICE" ]; then
    echo "❌ Đã hủy bỏ / Cancelled."
    exit 1
fi

LANG_CHOICE=$(echo "$LANG_CHOICE" | tr -d '"')

# Thiết lập ngôn ngữ hiển thị
if [ "$LANG_CHOICE" = "vi" ]; then
    TITLE="Trình cài đặt tự động của EricDg"
    TEXT="Bấm [Space] để chọn phần mềm cần cài, sau đó bấm Enter:"
    UP_MSG="🔄 Đang cập nhật hệ thống..."
    FETCH_MSG="⚡ Đang tải và thực thi script từ GitHub cho:"
    CLEAN_MSG="🧹 Đang dọn dẹp hệ thống tối ưu dung lượng..."
    SUCCESS_MSG="🎉 Đã cài đặt hoàn tất các phần mềm được chọn!"
    CANCEL_MSG="❌ Đã hủy bỏ quá trình cài đặt."
    CONFIRM_TITLE="Xác nhận cấu hình GitHub"
    CONFIRM_TEXT="Script sẽ tải các file cài đặt từ:\n$REPO_URL\n\nBạn có muốn tiếp tục không?"
else
    TITLE="EricDg's Auto Installer Suite"
    TEXT="Press [Space] to select software, then press Enter:"
    UP_MSG="🔄 Updating system registries..."
    FETCH_MSG="⚡ Fetching and executing remote script from GitHub for:"
    CLEAN_MSG="🧹 Cleaning up temporary setup files..."
    SUCCESS_MSG="🎉 Selected software installed successfully!"
    CANCEL_MSG="❌ Installation cancelled."
    CONFIRM_TITLE="Confirm GitHub Repository"
    CONFIRM_TEXT="Scripts will be fetched from:\n$REPO_URL\n\nDo you want to proceed?"
fi

# ===========================
# Bước 2: Checklist Chọn Phần Mềm
# ===========================
CHOICES=$(whiptail --title "$TITLE" \
    --checklist "$TEXT" 22 80 14 \
    "android-studio" "Android Studio IDE" OFF \
    "atom" "Atom Text Editor" OFF \
    "brave" "Brave Browser" OFF \
    "chrome" "Google Chrome Browser" ON \
    "chromium" "Chromium Browser" OFF \
    "coccoc" "Cốc Cốc Browser" OFF \
    "discord" "" OFF \
    "docker" "Docker Engine & Compose" OFF \
    "flameshot" "Công cụ chụp ảnh màn hình" OFF \
    "flatpak" "Hệ thống quản lý gói Flatpak" OFF \
    "flutter" "Flutter SDK Environment" OFF \
    "fonts" "" OFF \
    "gedit" "Trình soạn thảo văn bản Gedit" OFF \
    "gh" "GitHub CLI Tool" OFF \
    "git" "" OFF \
    "github-desktop" "GitHub Desktop Client" OFF \
    "htop" "Trình giám sát hệ thống Htop" ON \
    "joplin" "Ứng dụng ghi chú Joplin" OFF \
    "kvm-qemu" "Ảo hóa KVM/QEMU & Libvirt" OFF \
    "libreoffice" "Bộ ứng dụng văn phòng mã nguồn mở, miễn phí, và mạnh mẽ, thường được dùng làm giải pháp thay thế cho Microsoft Office" ON \
    "nodejs" "NodeJS (Quản lý phiên bản động)" OFF \
    "notepadplusplus" "Notepad++ (Snap/Wine)" OFF \
    "nvm" "Node Version Manager (NVM)" OFF \
    "obsidian" "" OFF \
    "oh-my-zsh" "" OFF \
    "postman" "Nền tảng phần mềm phổ biến giúp các lập trình viên và người kiểm thử (tester) thiết kế, xây dựng, chia sẻ và kiểm thử API" OFF \
    "python" "Python Environment (Dynamic)" OFF \
    "sublime-text" "Sublime Text Editor" OFF \
    "teamviewer" "TeamViewer Remote Desktop" OFF \
    "telegram" "Telegram Desktop Messenger" OFF \
    "vscode" "Visual Studio Code (Official)" OFF \
    "vscodium" "VSCodium (VS Code No Tracking)" OFF \
    "vysor" "Vysor Android Control" OFF \
    "warp" "Warp Terminal" OFF \
    3>&1 1>&2 2>&3)

# Nếu người dùng bấm Cancel ở bước chọn phần mềm
if [ $? -ne 0 ] || [ -z "$CHOICES" ]; then
    echo "$CANCEL_MSG"
    exit 1
fi

# Hiện hộp thoại xác nhận URL để tránh lỗi cấu hình sai link GitHub
whiptail --title "$CONFIRM_TITLE" --yesno "$CONFIRM_TEXT" 12 70
if [ $? -ne 0 ]; then
    echo "$CANCEL_MSG"
    exit 1
fi

# ===========================
# Bước 3: Tiến Hành Tải & Thực Thi
# ===========================
echo "--------------------------------------------------"
echo "$UP_MSG"
sudo apt update -y
echo "--------------------------------------------------"

# Xóa bỏ dấu ngoặc kép thừa từ Whiptail checklist để loop mảng
SELECTED_APPS=$(echo "$CHOICES" | tr -d '"')

for APP in $SELECTED_APPS; do
    echo "--------------------------------------------------"
    echo "$FETCH_MSG $APP"
    echo "🔗 URL: $REPO_URL/$APP.sh"
    echo "--------------------------------------------------"
    
    # Thực thi trực tiếp qua curl + bash một cách an toàn
    if curl -fsSL "$REPO_URL/$APP.sh" | bash; then
        echo "✅ Hoàn thành xử lý gói: $APP"
    else
        echo "⚠️  Lỗi: Không tải được hoặc script [$APP.sh] thất bại tại repo."
    fi
done

# ===========================
# Bước 4: Tự Động Dọn Dẹp
# ===========================
echo "--------------------------------------------------"
echo "$CLEAN_MSG"
sudo apt autoremove -y && sudo apt clean
echo "--------------------------------------------------"

# Hiện thông báo thành công đồng bộ giao diện whiptail
whiptail --title "$TITLE" --msgbox "$SUCCESS_MSG" 10 50
echo "$SUCCESS_MSG"
