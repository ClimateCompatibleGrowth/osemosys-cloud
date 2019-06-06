#bin/sh

set -e

# Only for docker?
# yum install -y sudo

# curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
# curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo

# Install all yum dependencies
# sudo yum install -y git gpg gcc gcc-c++ make glpk-utils tmux htop openssl-devel readline-devel zlib-devel postgresql-libs postgresql-devel yarn bzip2 tar wget

# Install asdf
# dir="/root/.asdf"

# if [[ ! -e $dir ]]; then
#   echo "$dir does not exist" 1>&2
#   git clone https://github.com/asdf-vm/asdf.git /root/.asdf --branch v0.7.2
#   echo -e '\n. $HOME/.asdf/asdf.sh' >> /etc/bashrc
# else
#   echo "$dir already exists" 1>&2
# fi
# source /etc/bashrc

# Install ruby
# asdf plugin-add ruby
# asdf install ruby 2.6.2

# Install GLPK
# https://en.wikibooks.org/wiki/GLPK/Linux_OS
# wget ftp://ftp.gnu.org/gnu/glpk/glpk-4.55.tar.gz
# tar -xzvf glpk-4.55.tar.gz
# cd glpk-4.55
# ./configure
# make
# sudo make install
# make clean
# cd ..
# rm -rf glpk-4.55*

# =========

# sudo yum install -y docker

# ==== 
# From ruby:
sudo yum install -y jq docker tmux htop
sudo service docker start
sudo usermod -aG docker ec2-user
sudo su - $USER

secret=$(aws secretsmanager get-secret-value --region eu-west-1 --secret-id OsemosysCloud-Prod | jq '.SecretString' | sed -e 's/^"//' -e 's/"$//' | tr -d '\')

database_url=$(echo $secret | jq -r '.DATABASE_URL')
master_key=$(echo $secret | jq -r '.RAILS_MASTER_KEY')

echo "export RAILS_MASTER_KEY=$master_key" >> /home/ec2-user/.bashrc
echo "export DATABASE_URL=$database_url" >> /home/ec2-user/.bashrc
source ~/.bashrc
docker pull yboulkaid/osemosys

# ^^^^^^^ IN AMI

docker run -it -e RAILS_ENV=production -e DATABASE_URL -e RAILS_MASTER_KEY yboulkaid/osemosys bundle exec rake solve_run[3]
