#!/bin/bash

# Проверка прав root
if [ "$EUID" -ne 0 ]; then
    echo "Запустите скрипт с правами root (sudo $0)."
    exit 1
fi

# Переменные
SERVER_IP="192.168.4.210"    # IP NFS-сервера
SERVER_DIR="/srv/share"     # Директория на сервере
CLIENT_MOUNT="/mnt"     # Точка монтирования на клиенте

# Установка клиента NFS
apt update && apt install -y nfs-common

# Создание точки монтирования
mkdir -p "$CLIENT_MOUNT"


# Настройка автомонтирования (через fstab)
if ! grep -q "$SERVER_IP:$SERVER_DIR" /etc/fstab; then
    echo "$SERVER_IP:$SERVER_DIR $CLIENT_MOUNT nfs vers=3,noauto,x-systemd.automount  0 0" >> /etc/fstab
    echo "Запись добавлена в fstab."
fi

# Монтирование всех точек из fstab
mount -a

# Перезапуск служб
systemctl daemon-reload
systemctl restart remote-fs.target 

echo "NFS-клиент настроен. Ресурс будет монтироваться автоматически."
