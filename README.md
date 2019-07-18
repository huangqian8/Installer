# 说明
![](https://img.shields.io/badge/language-bash-orange.svg)

Hexo环境配置、SSL证书获取、Shadowsocks代理软件、~~谷歌反向代理安装脚本~~

### 环境
系统：CentOS 7

### 功能
* 预安装环境，建立Hexo博客文件夹
```bash
bash install-hexo.sh
```

* 安装Cerbot，配置SSL证书（本脚本使用Let's Encrypt，其余SSL证书请自行安装）
```bash
bash install-certbot.sh
```

* 安装 Shadowsocks（鉴于gfw功能升级，不建议试用）
```bash
bash install-shadowsocks.sh
```

* 安装 Python 3.6.1（使用python3启动，默认python2.7.5不变）
```bash
bash install-python3.sh
```
