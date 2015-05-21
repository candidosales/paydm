paydm
=====

Sistema de pagamento DeMolay (PI)

# Install VPS

<!-- export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8" -->

sudo apt-get -y update
sudo apt-get -y upgrade

sudo adduser deploy
sudo adduser deploy sudo
su deploy

sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev

<!-- sudo apt-get install -y build-essential bison openssl libreadline6 libreadline6-dev libcurl4-openssl-dev git-core zlib1g zlib1g-dev  libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev curl

sudo apt-get install mysql-server mysql-client

sudo apt-get install ruby -->

# Faster Gem Installation
echo "gem: --no-ri --no-rdoc" >> ~/.gemrc
