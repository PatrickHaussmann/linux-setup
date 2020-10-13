cd ~

# new user
echo "password for user patrick"
adduser -q patrick
apt install sudo
usermod -aG sudo patrick

# install basic tools
apt install -y mosh sudo vim tmux unattended-upgrades fail2ban htop curl wget ufw stow git #zsh
apt autoremove -y

# ssh settings
echo "\nPermitRootLogin no\nPort 4863\nClientAliveInterval 360\nClientAliveCountMax 0\nPermitEmptyPasswords no\nAllowUsers patrick\nProtocol 2\nMaxAuthTries 3" | tee -a  /etc/ssh/sshd_config
service sshd restart

# unattended-upgrades
echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | sudo debconf-set-selections
sudo dpkg-reconfigure -f noninteractive unattended-upgrades

# allow cron
echo "root\npatrick" | sudo tee -a  /etc/cron.d/cron.allow

# uninstall not needed tools
apt purge xinetd nis yp-tools tftpd atftpd tftpd-hpa telnetd rsh-server rsh-redone-server -y

# ufw
ufw allow 4863/tcp comment 'ssh'
ufw allow http comment 'http'
ufw allow https comment 'https'
ufw allow mosh comment 'mosh'
ufw --force enable

# dotfiles
git clone --recursive https://github.com/PatrickHaussmann/dotfiles.git /home/patrick/dotfiles
mv /home/patrick/.bashrc /home/patrick/.bashrc.old
patrick@raspberrypi:~ $ cd /home/patrick/dotfiles/
for x in */; do stow $x; done

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

# jekyll
apt install -y ruby-full build-essential
gem install bundler jekyll

# should be last (because it exits this script)
# ohmyzsh
#sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"