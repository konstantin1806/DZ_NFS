#!/bin/bash

# Проверка прав root
if [ "$EUID" -ne 0 ]; then
    echo "Запустите скрипт с правами root (sudo $0)."
    exit 1
fi

# ввод переменных
SHARE_DIR="/srv/share"
CLIENT_IP="192.168.4.203"
OPTIONS="rw,sync,root_squash"

# Установка пакетов

apt update && apt install -y nfs-kernel-server

# Создание директории
mkdir -p "$SHARE_DIR"
chown -R nobody:nogroup "$SHARE_DIR"
chmod 0777 "$SHARE_DIR"

# Настройка exports
echo "$SHARE_DIR $CLIENT_IP($OPTIONS)" >> /etc/exports

# Включение и запуск служб
systemctl enable nfs-server
systemctl start nfs-server

# Применение настроек
exportfs -a

# Проверка
showmount -e localhost

# итоговое сообщение
echo "NFS-сервер настроен."
