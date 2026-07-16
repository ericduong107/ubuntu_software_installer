#!/bin/bash
echo "⚡ Tiến hành cài đặt hệ thống ảo hóa KVM/QEMU & Libvirt..."
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager -y
sudo adduser "$USER" libvirt
sudo adduser "$USER" kvm
echo "✓ Hoàn thành cài đặt KVM/QEMU!"