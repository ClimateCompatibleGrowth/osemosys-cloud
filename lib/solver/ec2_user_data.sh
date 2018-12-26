# TODO: Automate this to create new AMIs. Chef?
# Use Amazon linux 2 instead of linux

# Prerequisite to setup yarn
# https://yarnpkg.com/lang/en/docs/install/#centos-stable
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo

# Install all yum dependencies
sudo yum install -y git gpg gcc gcc-c++ make glpk-utils tmux htop openssl-devel readline-devel zlib-devel postgresql-libs postgresql-devel yarn

# Install ruby
wget -q https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer -O- | bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
rbenv install 2.5.1
gem install bundler

# Install CPLEX:
aws s3 cp "s3://osemosys-playground/cplex/cplex_studio128.linux-x86-64.bin" cplex_studio128.linux-x86-64.bin
chmod +x cplex_studio128.linux-x86-64.bin
sudo ./cplex_studio128.linux-x86-64.bin 
# ...go through installation
sudo ln -s /opt/ibm/ILOG/CPLEX_Studio128/cplex/bin/x86-64_linux/cplex /usr/bin/cplex

# Install GLPK
# https://en.wikibooks.org/wiki/GLPK/Linux_OS
wget ftp://ftp.gnu.org/gnu/glpk/glpk-4.55.tar.gz
tar -xzvf glpk-4.55.tar.gz
cd glpk-4.55
./configure
make
sudo make install

# Add to bashrc:
export RAILS_ENV=production
export RACK_ENV=production
export DATABASE_URL=
export RAILS_MASTER_KEY=

# Setup repo
git clone https://github.com/yboulkaid/osemosys-cloud.git
cd osemosys-cloud/

# Only install for prod?
bundle install

# Everything above here should be in the AMI
cd osemosys-cloud && bundle exec rake solve_run[2] && sudo shutdown -h now
