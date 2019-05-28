#!/bin/bash

# Update source of Raspbian
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo bash -c "cat > /etc/apt/sources.list" <<EOF
deb http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ stretch main non-free contrib
deb-src http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ stretch main non-free contrib
EOF

# Update source of Raspbian
sudo cp /etc/apt/sources.list.d/raspi.list /etc/apt/sources.list.d/raspi.list.bak
sudo bash -c "cat > /etc/apt/sources.list.d/raspi.list" <<EOF
deb http://mirrors.tuna.tsinghua.edu.cn/raspberrypi/ stretch main
EOF

# Install Python 3.7.3
sudo apt-get update -y
sudo apt-get install build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libffi-dev -y
wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tar.xz
tar xf Python-3.7.3.tar.xz
cd Python-3.7.3
./configure
make -j 4
sudo make altinstall
cd ..
sudo rm -r Python-3.7.3
rm Python-3.7.3.tar.xz
sudo apt-get --purge remove build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libffi-dev -y
sudo apt-get autoremove -y
sudo apt-get clean
python3.7 -V

# REMOVE PYTHON 2.7 & 3.5
sudo apt-get autoremove python2.7
sudo apt-get autoremove python3.5
sudo ln -s /usr/local/bin/python3.7 /usr/bin/python

# Install Scrapy
sudo apt-get install python-pip python-lxml python-crypto python-cssselect python-openssl python-w3lib python-twisted python-dev libxml2-dev libxslt1-dev zlib1g-dev libffi-dev libssl-dev -y
sudo pip install scrapy
