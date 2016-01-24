---
layout: post
title: "Mac OS X下编译jzmq"
date: 2014-05-08 18:48:58 +0800
comments: true
categories: TRUE
---
本文旨在帮助Mac OS X下的用户编译jzmq，本文出现的诸多问题也仅仅局限于MAC OS X，在RedHat、CentOS等系统环境下的用户未必会出现此类问题。

jzmq是为Java语言提供的一个可以与ZeroMQ进行通信的链接库。

安装jzmq之前请确认已经部署有JVM环境。

在MAC OS X下编译jzmq首先需要autotools，autotools环境需要三个lib：autoconf、automake和libtool。

###### 一、部署autotools环境：

1、为autotools创建安装目录：本文部署在/usr/local/devtools（可自定义）目录下，最好在环境变量下配置一下该路径，~/.bash_profile，

`export build=/usr/local/devtools`

使环境变量生效

`source ~/.bash_profile`

2、安装部署autoconf

在[http://mirrors.ustc.edu.cn/gnu/autoconf/](http://mirrors.ustc.edu.cn/gnu/autoconf/)目录下下载最新的autoconf，最新版本的命名为autoconf-latest.tar.gz

将autoconf-latest.tar.gz拷贝至$build目录下，解压缩

> cd $build
> 
> tar zxvf autoconf-latest.tar.gz
> 
> cd autoconf-latest
> 
> ./configure --prefix=$build/autotools-bin
> 
> make
> 
> make install

在~/.bash_profile下添加PATH环境变量

`export PATH=$PATH:$build/autotools-bin/bin`

3、安装部署automake

在[http://mirror.bjtu.edu.cn/gnu/automake/](http://mirror.bjtu.edu.cn/gnu/automake/)目录下下载最新的automake，最新版本的命名为automake-1.14.tar.gz

将automake-1.14.tar.gz拷贝至$build目录下，解压缩

> cd $$build
> 
> tar zxvf automake-1.14.tar.gz
> 
> cd automake-1.14
> 
> ./configure --prefix=$build/autotools-bin
> 
> make
> 
> make install

4、安装部署libtool

在[http://mirror.bjtu.edu.cn/gnu/libtool/](http://mirror.bjtu.edu.cn/gnu/libtool/)目录下下载最新的libtool，最新版本的命名为libtool-2.4.2.tar.gz

将libtool-2.4.2.tar.gz拷贝至$build目录下，解压缩

> cd $$build
> 
> tar zxvf libtool-2.4.2.tar.gz
> 
> cd libtool-2.4.2
> 
> ./configure --prefix=$build/autotools-bin
> 
> make
> 
> make install

###### 二、部署pkg-config

部署pkg-config可以借助于brew，brew是mac下一个类似于yum,apt-get等之类的工具，如果机器上没有这个命令的，请自行google。

`brew install pkg-config`

执行该命令之后pkg-config就自行安装好了，brew默认安装的路径为/usr/local/homebrew/Cellar（此路径根据你在安装brew定义的时候定义的）。

三、部署zeromq

到[http://download.zeromq.org/](http://download.zeromq.org/)目录下下载zeromq，建议下载2.2.0版本，下载之后拷贝至/usr/local目录下并进行解压缩

> tar zxvf zeromq-2.2.0.tar.gz
> 
> cd zeromq-2.2.0
> 
> ./configure --with-pgm
> 
> make
> 
> make install

四、下载安装jzmq

到[https://github.com/zeromq/jzmq](https://github.com/zeromq/jzmq)目录下git出jzmq，然后进入该目录执行如下命令：

`./autogen.sh`

`./configure`

在执行configure时可能会出现如下问题：

> autoreconf: Entering directory `.'
> autoreconf: configure.in: not using Gettext
> autoreconf: running: aclocal -I config --force -I config
> aclocal: warning: autoconf input should be named 'configure.ac', not 'configure.in'
> autoreconf: configure.in: tracing
> autoreconf: configure.in: not using Libtool
> autoreconf: running: /usr/local/homebrew/Cellar/autoconf/2.69/bin/autoconf --include=config --force
> configure.in:28: error: possibly undefined macro: AC_PROG_LIBTOOL
>       If this token and others are legitimate, please use m4_pattern_allow.
>       See the Autoconf documentation.
> autoreconf: /usr/local/homebrew/Cellar/autoconf/2.69/bin/autoconf failed with exit status: 1
> autogen.sh: error: autoreconf exited with status 0

解决方法如下：（以下命令参考于[http://stackoverflow.com/questions/3522248/how-do-i-compile-jzmq-for-zeromq-on-osx](http://stackoverflow.com/questions/3522248/how-do-i-compile-jzmq-for-zeromq-on-osx)）：

在控制台下执行如下两行命令：

> eval \`brew --config | grep HOMEBREW_PREFIX | sed 's/: /=/'`
> 
> sudo bash -c 'echo '$HOMEBREW_PREFIX/share/aclocal' >> \`aclocal --print-ac-dir`/dirlist'


执行上述命令如果出现如下问题：

> bash: aclocal: command not found

请加入aclocal的全路径：

> sudo bash -c 'echo '$HOMEBREW_PREFIX/share/aclocal' >> \`/usr/local/devtools/autotools-bin/bin/aclocal --print-ac-dir`/dirlist'

configure命令执行通过之后，执行

`make`

`sudo make install`

最后会在/usr/local/share/java/目录下生成zmq.jar包，在/usr/local/lib目录下生成native lib.

在部署过程中，可能还会出现其它问题，一般这些问题均是由缺少某个库引起的，安装相应的库便可解决这些问题。
