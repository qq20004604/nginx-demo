#!/bin/sh
# 打开80端口
# 由于在安装nginx的时候，会默认启动nginx，但有时候本机能访问（curl 127.0.0.1），但是其他机子访问不了
# 这是因为防火墙没有打开端口，例如CentOS 7 需要通过 firewalld 来打开 http 80 端口
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --reload