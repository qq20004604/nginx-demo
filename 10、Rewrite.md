## 10、Rewrite

### 1、基本概念

假如我访问的 URL 是 ``/abc``，因为某种原因，我需要实际访问的是后台资源的 ``/def.html``，这个时候就要用 Rewrite 技术了。

### 2、return

<b>语法：</b>

```
return code [其他，部分情况可选]
```

<b>使用环境：</b>

```
server、location、if
```

<b>作用描述：</b>

结束规则，并返回给客户端状态码（以及内容）。

当你需要简单暴力的给用户返回一个东西的时候，可用。

<b>常见示例：</b>

1、返回一个文件

```
# return code [text]; 返回一个文件给客户端，文件名是ok，内容是 "It's ok"
# 有等号表示精确匹配
location = /ok {
    return 200 "It's ok";
}
```

2、返回一个json（非需要下载的文件）

```
# return 200 JSON字符串; 返回一个json给客户端（包括content-type也会被自动修改）
# 要求URL以 .json 作为结尾
location = /ok.json {
    return 200 '{"a":"a"}';
}
```

3、重定向

```
# return code URL;
location = /baidu{
    # return 返回 302 状态码，触发重定向到百度首页。
    # 注意，如果换成200的话，就会变成下载一个网页页面
    return 302 https://www.baidu.com;
}
```

4、返回特殊状态码（如404）

```
# 返回404页面（nginx内置的404页面）
location = /404{
    return 404;
}
```

5、返回一个网页，但是带有特殊状态码的

返回一个网页，但是状态码是404，表示not found

```
location = /404.html{
    # <h1>和<br/> 是html标签，表示换行符
    return 404 "<h1>Sorry!</h1>Dear~<br/>Not Found~";
}
```

### 3、rewrite

<b>语法：</b>

```
rewrite regex replacement [flag];
```

<b>使用环境：</b>

```
server、location、if
```

<b>作用描述：</b>

就如上面所介绍，访问 /a ，实际上却访问的是 /b

可以使用正则匹配，可以将原链接一部分替换为自定义的内容。

<b>常见示例：</b>

1、最简单的 rewrite，符合要求后，重定向到目标链接。

下图示例中，访问和浏览器里显示的是 URL 是 ``/re``，返回内容的是 ``/ok.json``

```
location = /re {
    # 链接为 /re 即触发这里的代码，rewrite 为 /ok.json
    # 此时 URL 依然是 /re
    # 注意，/ok.json 的内容是在上面【2】中的示例定义的
    rewrite (.*) /ok.json;
}
```

2、取原本内容的一部分，作为新链接的一部分。

```
location = /ssoo{
    # /s(.{2})o 表示匹配 s 后面，非换行符字符，共计2个，最后是o。
    # 并将那2个字符（这里是so）赋值给 $1
    # 于是，j$1n 实际上指的是 json，/ok.j$1n 表示是 /ok.json
    # 注意，前面的要加引号，没有引号就会出错（但可以是单引号或者双引号）
    rewrite "/s(.{2})o" /ok.j$1n;
}
```

3、重定向到其他域名下。

访问c.test.com/my/files，会被自动重定向到 a.test.com/files （包括浏览器地址栏里的地址也会变，和一般的rewrite不同）。

```
location = /my/files{
    # 跨域名重定向，（例如c.test.com → a.test.com），会触发302重定向，导致浏览器窗口的域名改变
    # 非跨域名通常是不会的
    # 另外不能写成 //a.test.com 这种形式（即省略前面的 https?:）
    rewrite '/my/(.*)' http://a.test.com/$1;
}
```

4、访问一个 ``/a`` 开头的pathname，实际上访问的是 ``/b`` 开头的pathname。

例如：访问 ``/a/files``，实际到传到服务器的是 ``/b/files``

```
location /a/{
    # 将 /a/后匹配到所有字符，放在 /b/后面
    rewrite '/a/(.*)' /b/$1;
}
```

### 4、break 和 last

<b>语法：</b>

```
break
```

<b>使用环境：</b>

```
server、location、if
```

<b>语法：</b>

```
last
```

<b>使用环境：</b>

```
rewrite 语法中，第三个 [flag] 所在位置
```

<b>作用描述：</b>

需要和其他配合使用，终止当前匹配流程。

<b>注意：</b>需要在 ``rewrite`` 中，区分 break 和 last 关键字的区别。

<b>常见示例：</b>

需要和 last 对比来理解。

last 表示这次是最终匹配了（即这次 rewrite 匹配成功后，将去访问rewrite 后，在 nginx 里的 ``location`` 条件）；

break 如果位于 ``location`` 里，这次 rewrite 后，不再被locaiton 中后续规则匹配（包括同一个 server 下的其他 location）。而是直接访问该 location 的 root 文件夹里的文件。

具体来说，就是 rewrite 后为``/1.html``，实际上是访问该 location 中，root 所配置的文件夹（默认为 html ）下的文件，这里将会是 ``/html/1.html``（html为 nginx 里 html 文件夹）（这里有点绕，更具体的解释，看下面示例4）。

break 如果位于 ``server`` 下（和 location 平级），则会正常触发 location 里的匹配。

例如：

* 我想访问 ``/a/a/*`` 时，访问 ``/a.json``；
* 访问 ``/a/*`` 时（即非 ``/a/a`` ），跳转到 404 页面（nginx里自定义的location返回数据，而不是 html 文件下的）；
* 用 last 有两种写法，用 break 只有一种写法。

1、写在 server 中，如下：

```
server {
    listen 80;
    server_name c.test.com;

	 # 这里既可以用 break，也可以用 last
    rewrite /a/a/(.*) /a.json break;

    location ~ /a/{
        rewrite /(.*) /404.html last;
    }

    location = /a.json {
        return 200 '{"a":1}';
    }
    location = /404.html{
        return 404 "Not found!";
    }
}
```

2、写在 location 下

```
server {
    listen 80;
    server_name c.test.com;

    location ~ /a/{
        # 这里只能用 last，而不能用 break
        rewrite /a/a/(.*) /a.json last;
        rewrite /(.*) /404.html last;
    }

    location = /a.json {
        return 200 '{"a":1}';
    }
    location = /404.html{
        return 404 "Not found!";
    }
}
```

3、假如在 2 中的情况，使用了 last 会发生什么事情呢？

假如 nginx 根目录下的 html 里有 a.json 这个文件，则将访问到该目录下 ``a.json`` 这个文件，否则将报 nginx 自己的 404 错误页面。

4、假如，访问 ``/a/a/`` 开头的 pathname 时，认为不匹配，访问 ``html2/404.html`` 这里的文件，其他时候访问默认的 404 返回内容。

配置如下，解释见注释。

```
server {
    listen 80;
    server_name c.test.com;

    location ~ /a/{
        # 这里的 html2 指 nginx 根目录下的 html2 文件夹
        root    html2;
        # 访问 /a/a/ 时触发本条规则，将访问上面 root 选项配置的文件夹下的 404.html 文件
        rewrite /a/a/(.*) /404.html break;
        # 这里跳转到下面的location = /404.html 规则
        rewrite /(.*) /404.html last;
    }

    location = /404.html{
        return 404 "Not found!";
    }
}
```

### 5、if

<b>语法：</b>

```
if (判断条件) { 执行的命令 }
```

<b>使用环境：</b>

```
server、location
```

<b>作用描述：</b>




<b>常见示例：</b>
