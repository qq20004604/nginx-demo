程序员技术交流、面试、职场、生活、游戏，综合讨论QQ群：387017550，群内经常发红包，欢迎加入

---

### 01、安装

【1】ububtu平台、centos平台，参考：

https://wizardforcel.gitbooks.io/nginx-doc/content/Text/1.3_install.html

在安装【PCRE库】或者其他时，会出现找不到文件的情况，打开 ``ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/``，然后找符合你需要的版本，更改版本号即可。

如果提示没有权限``Permission denied`，则前面加 sudo 即可。

例如：【PCRE库】版本号是8.39，【zlib】版本号是：1.2.11，

另外，安装nginx的时候，执行``./configure``命令时，记得改后面的其他文件的路径（原因是版本号不同，文件名则不同）。

**错误说明：**

* 也有可能你通过上面那个链接，怎么也安装不了，那么换一个参考链接吧：

http://www.runoob.com/linux/nginx-install-setup.html

<b>Centos 7平台，可以直接运行本项目里的 ``install_nginx.sh`` 来自动安装</b>

【2】mac平台：

参考：https://www.jianshu.com/p/026d67cc6cb1

1、先执行，安装homebrew：

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

说明：

* 第一行命令执行完，需要按一次 return（回车键），和输一次密码；
* 过程比较久，因为需要下载一些东西；

2、再执行安装nginx：

```
brew install nginx
```

3、执行：

```
sudo xcode-select --install
```

不过他可能会提示：xcode-select: error: command line tools are already installed, use "Software Update" to install updates

那么就不管了吧

4、启动nginx服务

```
brew services start nginx
```

等可以继续输入命令的时候，打开：<a href='http://localhost:8080/'>http://localhost:8080/</a> 有正常显示，说明就ok了。

【3】其他平台：

参考：http://www.nginx.cn/doc/

<ul>
<li><a href="http://www.nginx.cn/doc/setup/nginx-windows.html">nginx在windows上安装</a></li>
<li><a href="http://www.nginx.cn/doc/setup/nginx-freebsd.html">nginx在freebsd上安装</a></li>
<li><a href="http://www.nginx.cn/doc/setup/nginx-ubuntu.html">nginx在ubuntu上安装</a></li>
<li><a href="http://www.nginx.cn/doc/setup/nginx-fedora.html">nginx在fedora上安装</a></li>
<li><a href="http://blog.s135.com/nginx_php_v5/" target="_blank">nginx在centos上安装</a></li>
<li><a href="http://www.nginx.cn/231.html" target="_blank" title="php-fpm安装配置">nginx php-fpm安装配置</a></li>
</ul>

【4】windows平台：

不支持，就是这样，装个虚拟机吧~

支持的操作系统：

```$xslt
FreeBSD 3.x, 4.x, 5.x, 6.x i386; FreeBSD 5.x, 6.x amd64;
Linux 2.2, 2.4, 2.6 i386; Linux 2.6 amd64;
Solaris 8 i386; Solaris 9 i386 and sun4u; Solaris 10 i386;
MacOS X (10.4) PPC;
```

【5】问题解决：

1、安装了nginx，也可以通过 curl 127.0.0.1 本机打开页面，但是其他机子访问不了，怎么解决？

解决办法：例如在CentOS 7 需要通过 firewalld 来打开 http 80 端口，才能访问。

参考本项目中的 [centos7_open_port_80.sh] 文件