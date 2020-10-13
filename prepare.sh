# change root password
# delete default user (userdel -r pi)

apt update && apt upgrade -y

apt install -y curl locales
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

sh -c "$(curl -fsSL https://gist.githubusercontent.com/PatrickHaussmann/272a57ab436d810d81bd45972a567d6e/raw/setup.sh)"