## 1、为什么通过sh脚本来安装

sh脚本即是 shell 脚本，他的好处是可以批量执行多行指令。

面对需要批量在多个机器安装部署环境，sh脚本极其方便，并且自动化。

## 2、安装 FTP

首先建议安装 ftp，这样就可以直接通过 FTP 将 sh脚本 传到服务器上，比手动通过 vi 来写脚本方便很多。

当然，也可以先通过 ``wget`` 直接下载 sh 脚本。比如将文件传到github上，然后在github上找到该文件，点击 【raw】按钮，获取该文件本身的下载链接。

如何安装 FTP，可以参考我这篇文章的第十小节：

https://github.com/qq20004604/notes/tree/master/%E5%A6%82%E4%BD%95%E4%BD%BF%E7%94%A8%E8%99%9A%E6%8B%9F%E6%9C%BA%E6%9D%A5%E8%BF%90%E8%A1%8Clinux#10%E8%AE%A9linux%E5%8F%AF%E4%BB%A5%E9%80%9A%E8%BF%87ftp%E6%9D%A5%E8%AE%BF%E9%97%AE

不安装FTP可以直接跳过这一节，不过还是建议安装吧，管理会很方便。

## 3、将 sh文件 并执行

怎么上传不用我教吧？windows可以参考上面的文章，下载 FileZilla Client 软件将文件上传到 linux 服务器，或者通过 wget 下载 sh文件 到linux服务器上。

如果从 github 下载的话，可以使用我的 <a href="https://github.com/qq20004604/nginx-demo/blob/master/install_nginx.sh">这个文件</a>，直接执行以下命令即可

```
cd /usr/src/
wget https://raw.githubusercontent.com/qq20004604/nginx-demo/master/install_nginx.sh
sh install_nginx.sh
```

最终输出结果应该是 nginx version: nginx/1.6.2

如何验证nginx是否启动成功？

执行 ``curl 127.0.0.1``，然后应该会显示一段 html 文本，如果显示了，就代表 nginx 启动成功。

## 4、打开80端口

启动成功后，我们可以尝试在其他电脑上访问本机的nginx服务。

首先通过 ``ip addr`` 或者 ``ifconfig`` 命令，找到 inet 后面的 ip地址，通常局域网中的地址是例如 ``192.168.0.106``这样的。

然后在其他电脑上，访问这个 ip 地址，理论上是可以打开页面的。

如果一直打不开，但nginx又启动成功，那么就很可能是 服务器对外端口没打开。以 centos7 为例，可以通过以下命令来打开80端口。

```
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --reload
```

或者直接下载这个 sh脚本

```
cd /usr/src/
wget https://raw.githubusercontent.com/qq20004604/nginx-demo/master/centos7_open_port_80.sh
sh centos7_open_port_80.sh
```


## 5、问题汇总

1、如果运行错误，比如执行的文件后面多几个字符的，可能是编码问题。

需要使用vi命令打开sh文件，然后使用 :set ff=unix 将脚本转为unix格式，而非dos格式。再:wq保存后运行。

2、依然执行不了？可能是缺少 && 连接符。

有的需要在每行命令末尾（除了最后一行和第一行），加 `` &&`` （空格和2个&符号），代表连续执行。