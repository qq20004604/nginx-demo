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