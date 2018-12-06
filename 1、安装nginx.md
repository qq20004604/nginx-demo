### 参考

http://www.nginx.cn/doc/

程序员技术交流、面试、职场、生活、游戏、相亲，综合讨论QQ群：387017550，群内经常发红包，欢迎加入

---

### 1、安装

【1】ububtu平台、centos平台，参考：

https://wizardforcel.gitbooks.io/nginx-doc/content/Text/1.3_install.html

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
