程序员技术交流、面试、职场、生活、游戏，综合讨论QQ群：387017550，群内经常发红包，欢迎加入

## 06、一个nginx服务器为多个域名服务

###1、效果解释

当用户访问不同域名（但这些域名指向同一个IP）时，让他们被同一个 Nginx 的不同 server 所处理。

类似 06 中访问不同 IP 被不同 server 处理，只不过这次是域名。

这样，用户不需要感知不同 IP，只要改一下域名，就可以由不同 IP 处理了。

<b>举例来说：</b>

我有两个域名：``a.test.com`` 和 ``b.test.com``，和一个Nginx服务器。

用户访问 ``a.test.com`` 时，访问 Nginx 的第一个 server，

用户访问 ``b.test.com`` 时，访问 Nginx 的第二个 server，

好处就像【06、一个nginx服务器为多个ip服务】中提到的，用户只需要保存一个地址就可以了，无需关心你服务器端是怎么实现怎么处理的。

###2、实现方法

####2.1、确定可访问的 IP 地址

本地测试的话，先确定自己服务器的 IP 地址，可以通过 ``ifconfig`` 来查看，或者自己添加服务器的 IP 别名。

不管哪种方式，假定这个 IP 为 ``192.168.0.151`` ，即用户可以通过这个 IP 访问到你的 Nginx 服务器。

####2.2、修改host创造访问环境

这一步的目的是让客户端访问不同的域名，但访问的是同一个 IP。

实际线上无法干扰客户端，但也有办法能做到不同的域名指向同一个 IP。

打开你的 host（这里指客户端的 host），以 windows 为例，目录是 ``C:\Windows\System32\drivers\etc``。

将host文件复制到桌面，在最后添加一行，代表访问 ``a.test.com``或``b.test.com``，都访问的是 ``192.168.0.151`` 这个 IP 地址。

```
192.168.0.151   a.test.com b.test.com
```

####2.3、配置 Nginx

然后配置 Nginx 的 nginx.conf 文件，添加两个 server。

```
server {
    listen       80;
    server_name  a.test.com;

    location / {
        root   html;
        index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }
}

server {
    listen       80;
    server_name  b.test.com;

    location / {
        root   html2;
        index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }
}
```

这代表访问 ``a.test.com`` 时，访问的是 Nginx 文件夹下的 html 文件夹里的 index.html 文件；

这代表访问 ``b.test.com`` 时，访问的是 Nginx 文件夹下的 html2 文件夹里的 index.html 文件；

####2.4、让两个server打开的页面内容不同

将原本 nginx 文件夹下的 html 文件夹，复制一份，改名 html2；

更改 html2/index.html 的内容，例如删除正文；

####2.5、重新加载 Nginx 配置文件

上面我们修改了 nginx.conf 文件（不管你是直接 vi 改文件修改，或者是 FTP 下载到客户端修改后再上传覆盖）。

我们需要使其生效，执行 ``nginx -s reload`` 命令，让 Nginx 使用新的配置文件。

####2.6、查看效果

分别打开 ``a.test.com`` 和 ``b.test.com``，我们会发现打开的页面是不同的。

####2.7、总结

server 端的核心是 【2.2】、【2.3】、【2.4】、【2.5】，这是使其生效的关键。

其中【2.2】在外网的实现方法，通常是通过配置 DNS 解析来实现的。

这里客户端本地改 host 是为了方便的查看效果。