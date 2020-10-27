cd ~

# new user
echo "password for user patrick"
adduser -q patrick
apt install sudo
usermod -aG sudo patrick

# install basic tools
apt install -y mosh sudo vim tmux unattended-upgrades fail2ban htop curl wget ufw stow git httpie jq
apt autoremove -y

# ssh settings
echo "\nPermitRootLogin no\nPort 4863\nClientAliveInterval 360\nClientAliveCountMax 0\nPermitEmptyPasswords no\nAllowUsers patrick\nProtocol 2\nMaxAuthTries 3" | tee -a  /etc/ssh/sshd_config
service sshd restart

# unattended-upgrades
echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections
sudo dpkg-reconfigure -f noninteractive unattended-upgrades

# allow cron
echo "root\npatrick" | tee -a  /etc/cron.d/cron.allow

# uninstall not needed tools
apt purge xinetd nis yp-tools tftpd atftpd tftpd-hpa telnetd rsh-server rsh-redone-server -y

# ufw
ufw allow 4863/tcp comment 'ssh'
#ufw allow http comment 'http'
#ufw allow https comment 'https'
ufw allow mosh comment 'mosh'
ufw --force enable

# create folder
mkdir github

# github ssh key
sudo -u patrick ssh-keygen -t rsa -N "" -b 4096 -f /home/patrick/.ssh/github_rsa

# dotfiles
sudo -u patrick git clone --recursive https://github.com/PatrickHaussmann/dotfiles.git /home/patrick/dotfiles
sudo -u patrick mv /home/patrick/.bashrc /home/patrick/.bashrc.old
cd /home/patrick/dotfiles/
for x in */; do sudo -u patrick stow $x; done
cd ..

# install npm
curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
VERSION=node_14.x
DISTRO="$(lsb_release -s -c)"
echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list
echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" | tee -a /etc/apt/sources.list.d/nodesource.list
apt update
apt install nodejs

# install prettier
npm install -g prettier

# python3
apt install python3 python3-pip
pip3 install numpy pandas requests matplotlib scipy seaborn sympy


# install jekyll
# apt install -y ruby-full build-essential
# gem install bundler jekyll

echo """
github ssh:

add .ssh/gihub_rsa.pub to github

---------------------------

dotfiles:

# Back up/delete any conflicts, if a system has files in place already. The stow dry run command will produce errors if files would conflict:
# From the dotfiles dir
for x in */; do stow -n \$x; done

# Stow makes symlinking everything easy:

# From the dotfiles dir
for x in */; do stow \$x; done


delete default user:
userdel -r pi

""" | sudo -u patrick tee /home/patrick/TODO.txt
