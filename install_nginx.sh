#!/bin/sh
# centos 安装 nginx
# 参考链接 http://www.runoob.com/linux/nginx-install-setup.html
# 最终输出结果应该是 nginx version: nginx/1.6.2
# 运行错误提示：需要使用vi命令打开sh文件，然后使用 :set ff=unix 将脚本转为unix格式，而非dos格式。再:wq保存后运行
yum -y install make zlib zlib-devel gcc-c++ libtool openssl openssl-devel
cd /usr/local/src/
yum -y install wget
wget http://downloads.sourceforge.net/project/pcre/pcre/8.35/pcre-8.35.tar.gz
tar zxvf pcre-8.35.tar.gz
cd pcre-8.35
./configure
make
make install
cd /usr/local/src/
wget http://nginx.org/download/nginx-1.6.2.tar.gz
tar zxvf nginx-1.6.2.tar.gz
cd nginx-1.6.2
./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-pcre=/usr/local/src/pcre-8.35
make
make install
/usr/local/nginx/sbin/nginx -v
ln -s /usr/local/nginx/sbin/nginx /usr/bin/