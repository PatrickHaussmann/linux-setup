cd ~

# new user
echo "password for user patrick"
adduser -q patrick
apt install sudo
usermod -aG sudo patrick

# install basic tools
apt install -y mosh sudo vim tmux zsh unattended-upgrades fail2ban htop curl wget ufw stow git
apt autoremove -y

# ssh settings
echo "\nPermitRootLogin no\nPort 4863\nClientAliveInterval 360\nClientAliveCountMax 0\nPermitEmptyPasswords no\nAllowUsers patrick\nProtocol 2\nMaxAuthTries 3" | tee -a  /etc/ssh/sshd_config
service sshd restart

# dotfiles
git clone --recursive https://github.com/PatrickHaussmann/dotfiles.git

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

echo """
---------------------------
dotfiles:


# Back up/delete any conflicts, if a system has files in place already. The stow dry run command will produce errors if files would conflict:

# From the dotfiles dir
for x in */; do stow -n \$x; done


# Stow makes symlinking everything easy:

# From the dotfiles dir
for x in */; do stow \$x; done


---------------------------
"""

# should be last (because it exits this script)
# ohmyzsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"