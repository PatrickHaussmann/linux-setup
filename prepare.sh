# change root password

apt update && apt upgrade -y

apt install -y curl locales
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
locale-gen en_GB.UTF-8

sh -c "$(curl -fsSL https://gist.githubusercontent.com/PatrickHaussmann/272a57ab436d810d81bd45972a567d6e/raw/setup.sh)"