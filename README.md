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

<a href='https://github.com/qq20004604/nginx-demo/blob/master/02~04、目录和命令.md'>02~04、目录和命令</a>

<a href='https://github.com/qq20004604/nginx-demo/blob/master/05、配置nginx的配置文件.md'>05、配置nginx的配置文件</a>

<a href='https://github.com/qq20004604/nginx-demo/blob/master/06、一个nginx服务器为多个ip服务.md'>06、一个nginx服务器为多个ip服务</a>

<a href='https://github.com/qq20004604/nginx-demo/blob/master/07、一个nginx服务器为多个域名服务'>07、一个nginx服务器为多个域名服务</a>


##08、日志

Nginx里，日志配置是在 http 里，默认配置如下：

```
#    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
#                      '$status $body_bytes_sent "$http_referer" '
#                      '"$http_user_agent" "$http_x_forwarded_for"';

#    access_log  logs/access.log  main;
```

说明：

* log_format 表示日志格式，main 表示该格式名；
* access_log 表示日志存放位置，main 表示采用格式名为 mian 的日志格式；
* remote_addr：远程客户端用户的 IP；
* $remote_user：远程客户端用户名称；
* $time_local：时间和时区；
* $resuest：请求方式（比如GET）、请求URL（比如/）、HTTP协议（比如HTTP/1.1)；
* $status：HTTP状态码，例如成功是200，未找到是404；
* $body_bytes_send：发送给客户端的主体文件内容大小，不包括响应头的大小； 该变量与Apache模块mod_log_config里的“%B”参数兼容；
* $http_referer：从哪个链接访问过来的（但非重定向可能为空）；
* $http_x_forwarded_for：重定向之前，用户真实的 IP 地址；

<br/>
以下是我从<a href="http://www.ttlsa.com/linux/the-nginx-log-configuration/">其他地方（附链接）</a>拷贝过来的，仅供参考；

```
参数                      说明                                         示例
$remote_addr             客户端地址                                    211.28.65.253
$remote_user             客户端用户名称                                --
$time_local              访问时间和时区                                18/Jul/2012:17:00:01 +0800
$request                 请求的URI和HTTP协议                           "GET /article-10000.html HTTP/1.1"
$http_host               请求地址，即浏览器中你输入的地址（IP或域名）     www.wang.com 192.168.100.100
$status                  HTTP请求状态                                  200
$upstream_status         upstream状态                                 　200
$body_bytes_sent         发送给客户端文件内容大小，不包括响应头的大小         1547
$http_referer            url跳转来源                                   https://www.baidu.com/
$http_user_agent         用户终端浏览器等信息                           "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; SV1; GTB7.0; .NET4.0C;
$ssl_protocol            SSL协议版本                                   TLSv1
$ssl_cipher              交换数据中的算法                               RC4-SHA
$upstream_addr           后台upstream的地址，即真正提供服务的主机地址     10.10.10.100:80
$request_time            整个请求的总时间                               0.205
$upstream_response_time  请求过程中，upstream响应时间                    0.002

补充内容：
$bytes_sent             发送给客户端的总字节数。
$connection             连接的序列号。
$connection_requests    当前通过一个连接获得的请求数量。
$msec                   日志写入时间。单位为秒，精度是毫秒。
$pipe                 　如果请求是通过HTTP流水线(pipelined)发送，pipe值为“p”，否则为“.”。
$request_length         请求的长度（包括请求行，请求头和请求正文）。
$time_iso8601           ISO8601标准格式下的本地时间。
```


我们可以根据自己实际需要改为：

```
log_format mylogformat '$http_x_forwarded_for | "$http_referer" |  $remote_user | '
                    '$time_local | $http_host | "$request" | $status | $body_bytes_sent | '
                    '"$http_user_agent"';
access_log  logs/access2.log  mylogformat;
```


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

