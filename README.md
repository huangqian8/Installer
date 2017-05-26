# 说明
Hexo环境配置、SSL证书获取、Shadowsocks代理软件、谷歌反向代理安装脚本

### 测试环境
系统：CentOS 7

### 安装步骤
####   1、下载安装器
```bash
yum -y install git
git clone https://github.com/huangqian8/installer.git
cd installer
```

####   2、预安装环境，建立Hexo博客文件夹
```bash
bash install-hexo.sh
```

####   3、初始化本地仓库（本地非服务器端配置）
```bash
git init
ssh-copy-id -f -i ~/.ssh/id_rsa.pub -p PORT USERNAME@DOMAIN NAME or IP
git remote add origin ssh://USERNAME@DOMAIN NAME or IP:PORT/home/huangqian/blog/git
```

####   4、安装Cerbot，配置SSL证书（本脚本使用Let's Encrypt，其余SSL证书请自行安装）
```bash
bash install-certbot.sh
```

####   5、安装 Shadowsocks（可独立安装，选配，非必需）
```bash
bash install-shadowsocks.sh
```