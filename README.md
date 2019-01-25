# nginx-demo 

### nginx的学习笔记

### 参考

http://www.nginx.cn/doc/

程序员技术交流、面试、职场、生活、游戏、相亲，综合讨论QQ群：387017550，群内经常发红包，欢迎加入

### 0、命令行工具

由于需要涉及到比较多的命令行输入，所以建议搞一个专业的命令行工具，mac自带的终端功能并不强大。

<b>iTerm2</b>，参考：https://www.jianshu.com/p/33f2048b8862

---

### 目录

<a href='https://github.com/qq20004604/nginx-demo/blob/master/01、安装nginx.md'>01、安装nginx</a>

<a href='https://github.com/qq20004604/nginx-demo/blob/master/02、默认目录.md'>02、默认目录</a>

<a href='https://github.com/qq20004604/nginx-demo/blob/master/03、nginx常用命令.md'>03、nginx常用命令</a>

<a href='https://github.com/qq20004604/nginx-demo/blob/master/04、配置nginx的配置文件.md'>04、配置nginx的配置文件</a>

<a href='https://github.com/qq20004604/nginx-demo/blob/master/05、一个nginx服务器为多个ip服务.md'>05、一个nginx服务器为多个ip服务</a>

<a href='https://github.com/qq20004604/nginx-demo/blob/master/06、一个nginx服务器为多个域名服务'>06、一个nginx服务器为多个域名服务</a>

<a href='https://github.com/qq20004604/nginx-demo/blob/master/07、日志'>07、日志</a>
 

### xx、根目录

在配置 ``nginx.conf`` 文件时，经常要涉及到目录的配置。

在默认配置文件中，路径里写的都是相对路径，这个相对路径，其基础指的就是 nginx 的安装目录。

那么如何确定 nginx 的安装目录呢？

linux下可以使用这个命令：

```
ps -ef | grep nginx  
```

mac下不行，不会显示目录，但是更简单，直接在这个目录下找吧 ``/usr/local/Cellar/nginx/``


### xx、主进程pid

当我们需要控制 nginx 的主进程时，我们需要知道主进程的 pid

获取pid时，可以通过 nginx.pid 来获取，里面只有一个值，就是 主进程的 pid 的值；

一般他在 ``/usr/local/nginx/nginx.pid`` 中，如果你按照我的方式来安装的话，他应该在 ``/usr/local/var/run/nginx.pid`` 中。

如果需要迁移（例如 ``nginx.conf`` 里，这个文件应该在 ``nginx/logs`` 这个目录中。但在mac里，他并不是）

那么就在命令行中，先进入目标目录（如在 ``nginx/logs`` 目录下），输入以下命令移动文件：

```$xslt
mv /usr/local/var/run/nginx.pid ./
```

拿到主进程pid的意义在哪，待后续补充；

```
// todo 待补充
```

### 08、信号处理

这篇文章讲的比较好：

<a href="https://blog.csdn.net/zwan0518/article/details/49851273">nginx介绍-信号处理</a>

