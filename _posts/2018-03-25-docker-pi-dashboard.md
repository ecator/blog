---
layout: post
title: 一行命令部署pi dashboard
author: 易小猫
tags: pi docker php
---

玩树莓派的小伙伴肯定知道[pi dashboard](https://github.com/spoonysonny/pi-dashboard)这个工具，它是一个用php写的树莓派状态检测工具，[官方也有教程](http://maker.quwj.com/project/10)详细说明了各种部署方法，但对于刚接触树莓派或者对Linux不熟悉的小伙伴来说略显麻烦，而且对于爱折腾的玩家树莓派可能经常重装系统，所以为了偷个懒，利用树莓派上的docker来一键部署pi dashboard :smiley:
<!--description-->

> 这里简单介绍一下docker，docker可以提供一个虚拟运行环境，相当于一个轻量级的虚拟机，一般称这个虚拟环境叫做**容器**，而现在很多软件的一个问题就是可能在我的电脑能跑，但是到了你的电脑就不能跑了，这就是大家的运行环境千差万别造成的，虽然好多软件提供源码直接让用户编译，但是要想真正运行起来还有很多繁琐的步骤，所以就诞生了**软件即环境**的思想，意思就是发布软件的同时连同运行环境一起打包，而docker就是专门解决这个的。

而这次我们就是把pi dashboard整个打包进docker构建一个容器，当然打包工作我已经做好了，有兴趣的小伙伴可以参考[git项目地址](https://github.com/ecator/docker-pi-dashboard):smile:

# 安装docker
工欲善其事必先利其器，要运行这个容器第一步肯定是要安装docker：
```
sudo apt update
sudo apt install docker
```
> 树莓派的docker和普通发行版的docker不太一样，树莓派的docker是32位的，不过这对我们不影响

# 运行容器

安装完docker后就可以用下面的命令启动pi dashboard容器了 :relaxed:

```
sudo docker run -d --name docker-pi-dashboard -e 'LISTEN=1024' --net=host ecat/docker-pi-dashboard
```

- `-d`代表以守护进程运行，也就是后台运行，不然会一直挂在前台
- `--name docker-pi-dashboard`表示启动后的容器名，可以自定义，以后可以根据这个名字来进行停止删除操作等
- `LISTEN=1024` 代表监听`1024`端口，这样你就可以通过`树莓派地址:1024`来访问pi dashboard，如果不写`-e 'LISTEN=1024'`就默认监听80端口
- `--net=host` 是非常重要也是必须，表示容器不启用新的网络栈，这样pi dashboard才能获得宿主机也就是树莓派的网络状态，不然获取的是容器的状态，并不是树莓派实际的状态
- `ecat/docker-pi-dashboard`是我已经构建好的镜像名，第一次启动的时候因为大家的树莓派还没有这个镜像，所以会自动下载，需要耐心等待一下

可以通过`sudo docker ps | grep docker-pi-dashboard`来确认我们的容器是否启动成功，如果启动成功，并且假设你的树莓派地址是`192.168.1.10`，那么就可以在浏览器中输入`http://192.168.1.10:1024`来访问pi dashboard了 :blush:

# 容器管理
这里假设启动的pi dashboard的容器名就叫`docker-pi-dashboard`
## 查看容器状态
`sudo docker ps -a`可以查看启动的所有容器，当然要查看我们启动的`docker-pi-dashboard`的详细状态就可以用如下命令
```
sudo docker inspect docker-pi-dashboard
```

## 停止容器
```
sudo docker stop docker-pi-dashboard
```
## 删除容器
我们停止pi dashboard的容器后实际上还是有缓存的，所以当再次用上面的命令启动pi dashboard容器时会报重复的错误，所以需要先删除掉
```
sudo docker rm -f docker-pi-dashboard
```
- `-f`可以不用先停止容器而直接删除
- 当然也可以不用删除直接从缓存运行容器，不过再次运行的命令就变成了`sudo docker run docker-pi-dashboard` :sweat_smile:

## 开机自启

开机自启无非就是在开机的时候运行**启动容器的命令**，所以一般做法是把命令加入到`/etc/rc.local`中：

```
# 检测是否有pi dashboard容器的缓存，有就删除掉
docker inspect docker-pi-dashboard >/dev/null 2>&1 && docker rm -f docker-pi-dashboard >/dev/nul 2>&1
# 启动pi dashboard的容器，监听80端口
docker run -d --name docker-pi-dashboard --net=host ecat/docker-pi-dashboard >/dev/null 2>&1
```

---
刚才也提到过，运行在pi上的docker和其他发行版linux上的docker不太一样，所以以上操作在树莓派官方系统中测试通过，关于其他系统爱折腾的小伙伴可以自己试试。