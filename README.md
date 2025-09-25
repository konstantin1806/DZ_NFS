# DZ_NFS

автоматическое развертывание на сервере и клиенте реализовано в скриптах (есть в репозитории):

server_nfs.sh
client_nfs.sh

перед запуском даем скриптам права на выполнение:

chmod +x server_nfs.sh

chmod +x client_nfs.sh

далее выполняется проверка работоспособности по условиям задания (основные моменты):

1. создание файла test.txt на сервере в каталоге /srv/share/upload с одновременной проверкой наличия в /mnt/upload на клиенте.

root@kokapc2:/srv/share/upload# touch test.txt
root@kokapc2:/srv/share/upload#

root@konstantinpc:/mnt/upload# ls
test.txt


2. после перезагрузки клиента данные в /srv/share/upload и /mnt/upload сохраняются.


3. вывод exportfs -s и showmount -a 192.168.4.210 на сервере.

root@kokapc2:/srv/share/upload# exportfs -s
/srv/share/ 192.168.4.203(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)

root@kokapc2:/srv/share/upload# showmount -a 192.168.4.210
All mount points on 192.168.4.210:
192.168.4.203:/srv/share


4. вывод showmount -a 192.168.4.210 на клиенте.

root@konstantinpc:/mnt/upload# showmount -a 192.168.4.210
All mount points on 192.168.4.210:
192.168.4.203:/srv/share


5. вывод mount | grep mnt на клиенте.

root@konstantinpc:/mnt/upload# mount | grep mnt
nsfs on /run/snapd/ns/lxd.mnt type nsfs (rw)
systemd-1 on /mnt/upload type autofs (rw,relatime,fd=42,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=52184)
systemd-1 on /mnt type autofs (rw,relatime,fd=50,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=54632)
192.168.4.210:/srv/share on /mnt type nfs (rw,relatime,vers=3,rsize=262144,wsize=262144,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.4.210,mountvers=3,mountport=39524,mountproto=udp,local_lock=none,addr=192.168.4.210)
