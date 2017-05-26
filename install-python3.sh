#!/bin/bash
# install-python3.sh
cd ~
clear

# 设置Python安装版本
# 可自行修改为任意版本
VERSION_UPDATE=3.6.1

# 下载源码并解压
wget https://www.python.org/ftp/python/${VERSION_UPDATE}/Python-${VERSION_UPDATE}.tgz && tar -xvf Python-${VERSION_UPDATE}.tgz

# 进入解压后的文件夹
cd Python-${VERSION_UPDATE}

# 新建python更新版本文件夹（作为python的安装路径，以免覆盖老的版本，新旧版本可以共存的)
mkdir /usr/local/python${VERSION_UPDATE}

# 安装依赖
yum -y update
yum -y install openssl openssl-devel zlib-devel gcc

# 编译安装
./configure --prefix=/usr/local/python${VERSION_UPDATE}
make && make install

# 建立新版本python的软链接
ln -s /usr/local/python${VERSION_UPDATE}/bin/python3.6 /usr/bin/python3
python3 -V
ln -s /usr/local/python${VERSION_UPDATE}/bin/pip3.6 /usr/bin/pip3
pip3 -V