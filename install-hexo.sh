#!/bin/bash
# install-hexo.sh
clear

# Fix Beijing time
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# Make sure if it is run by root
if [ `whoami` != root ]; then
    echo "This script must be run as root!"
    exit 0
fi

# Input the hostname of Centos
echo -e "\033[41;36;1m This script install Hexo on CentOS \033[0m"
echo "Please input your hostname(eg:blog.huangqian.me):"
read HOSTNAME

# Installing Utilities
echo -e "\033[41;36;1m Installing Utilities \033[0m"
yum -y update
yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
yum -y install perl-ExtUtils-MakeMaker
yum -y install gcc gcc-c++ make openssl
yum -y install wget

# Install Git from SourceCode
echo -e "\033[41;36;1m Installing Git \033[0m"
yum -y remove git
cd /usr/src
wget https://www.kernel.org/pub/software/scm/git/git-2.20.1.tar.gz
tar -zxvf git-2.20.1.tar.gz
cd git-2.20.1
make prefix=/usr/local/git all
make prefix=/usr/local/git install
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
source /etc/bashrc
git --version

# Configuring installation source of Nginx
echo -e "\033[41;36;1m Configuring installation source of Nginx \033[0m"
cat <<EOF > /etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=0
enabled=1
EOF

# Installing Nginx
echo -e "\033[41;36;1m Installing Nginx \033[0m"
yum install -y nginx
systemctl enable nginx
systemctl start nginx
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=443/tcp --permanent
firewall-cmd --reload

# Installing Node.js
echo -e "\033[41;36;1m Installing Node.js \033[0m"
curl --silent --location https://rpm.nodesource.com/setup_11.x | bash -
yum install -y nodejs

# Create a new user
echo -e "\033[41;36;1m Create a new user \033[0m"
echo "Please input username you want add(eg:huangqian):"
read USERNAME
useradd -d /home/$USERNAME -m -r -U -s /bin/bash $USERNAME
passwd $USERNAME
usermod -aG nginx $USERNAME
usermod -aG wheel $USERNAME

# Create authorized_keys
echo -e "\033[41;36;1m Create authorized_keys \033[0m"
mkdir -p /home/$USERNAME/.ssh
touch /home/$USERNAME/.ssh/authorized_keys
cd /etc/ssh
sed -i 's/#RSAAuthentication/RSAAuthentication/g' sshd_config
sed -i 's/#PubkeyAuthentication/PubkeyAuthentication/g' sshd_config
sed -i 's/#StrictModes yes/StrictModes no/g' sshd_config
sed -i 's/#Port 22/Port 25800/g' sshd_config
firewall-cmd --add-port=25800/tcp --permanent
firewall-cmd --reload
systemctl restart sshd.service

# Create blog folder
echo -e "\033[41;36;1m Create blog folder \033[0m"
mkdir -p /home/$USERNAME/blog/web
mkdir -p /home/$USERNAME/blog/git
mkdir -p /home/$USERNAME/blog/hexo
mkdir -p /home/$USERNAME/www

# Installing Hexo
echo -e "\033[41;36;1m Installing Hexo \033[0m"
cd /home/$USERNAME/blog/web
npm install -g hexo-cli
hexo init && npm install --save
npm install hexo-generator-sitemap --save # 站点地图
npm install hexo-generator-baidu-sitemap --save #百度站点地图
npm install hexo-generator-json-content --save # 站内搜索功能
npm install hexo-baidu-url-submit --save # 百度主动提交
npm install hexo-generator-search --save # 本地站内搜索
npm install hexo-tag-post-link --save # Hexo博客添加文章链接
npm install hexo-wordcount --save # 文章字数统计
mkdir -p /home/$USERNAME/blog/web/public

# Configuring Nginx
echo -e "\033[41;36;1m Configuring Nginx \033[0m"
cat <<EOF > /home/$USERNAME/$HOSTNAME.conf
server 
{
    listen 80;
    listen [::]:80;
    server_name $HOSTNAME;
    root /home/$USERNAME/blog/web/public;
    index index.html;
    location ~ /.well-known {
        allow all;
    }
}
EOF
ln -sf /home/$USERNAME/$HOSTNAME.conf /etc/nginx/conf.d/
nginx -t && nginx -s reload

# Create a bare repository on the server
echo -e "\033[41;36;1m Create a bare repository on the server \033[0m"
cd /home/$USERNAME/blog/git
git init --bare

# Create post-receive
echo -e "\033[41;36;1m Create post-receive \033[0m"
cat <<EOF > /home/$USERNAME/blog/git/hooks/post-receive
#!/bin/bash
deploy_to_dir="/home/$USERNAME/blog/hexo"
GIT_WORK_TREE=\$deploy_to_dir git checkout -f master
echo "DEPLOY:   master  copied to  \$deploy_to_dir"
hexo_dir="/home/$USERNAME/blog/web"
cd \$hexo_dir
hexo clean && hexo g -d --silent
if [[ \$? == 0 ]]
then
    echo "Congratulations! Your blog has been correctly deployed"
else
    echo "Unfortunately your blog has not been deployed correctly"
fi
EOF

# Begin Hexo
echo -e "\033[41;36;1m Begin Hexo \033[0m"
cd /home/$USERNAME/blog/web
rm -rf source scaffolds themes _config.yml
ln -sf /home/$USERNAME/blog/hexo/source .
ln -sf /home/$USERNAME/blog/hexo/scaffolds .
ln -sf /home/$USERNAME/blog/hexo/themes .
ln -sf /home/$USERNAME/blog/hexo/_config.yml .

# Configuring Privilege
echo -e "\033[41;36;1m Configuring Privilege \033[0m"
chown -R $USERNAME:nginx /home/$USERNAME
chmod -R 775 /home/$USERNAME
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys
