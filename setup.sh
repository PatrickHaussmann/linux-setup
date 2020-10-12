cd ~

# new user
echo "password for user patrick"
adduser -q patrick
apt install sudo
usermod -aG sudo edman

# install basic tools
apt install -y mosh sudo vim tmux zsh unattended-upgrades fail2ban htop curl wget ufw stow git
apt autoremove -y

# ssh settings
#sed -i 's/PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
#echo -e "\nPort 4863\nClientAliveInterval 360\nClientAliveCountMax 0\nPermitEmptyPasswords no\nAllowUsers patrick\nProtocol 2\nMaxAuthTries 3" | tee -a  /etc/ssh/sshd_config
#/etc/init.d/ssh restart

# ohmyzsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# dotfiles
git clone https://github.com/PatrickHaussmann/dotfiles.git

# unattended-upgrades
echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | sudo debconf-set-selections
sudo dpkg-reconfigure -f noninteractive unattended-upgrades

# allow cron
echo -e "root\npatrick" | sudo tee -a  /etc/cron.d/cron.allow

# uninstall not needed tools
apt purge xinetd nis yp-tools tftpd atftpd tftpd-hpa telnetd rsh-server rsh-redone-server -y

# ufw
ufw allow 4863/tcp comment 'ssh'
ufw allow http comment 'http'
ufw allow https comment 'https'
ufw allow mosh comment 'mosh'
ufw enable
