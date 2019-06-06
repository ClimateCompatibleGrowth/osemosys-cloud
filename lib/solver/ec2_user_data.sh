# TODO: Automate this to create new AMIs. Chef?

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
rbenv global 2.5.1
gem install bundler

# Install CPLEX:
aws s3 cp "s3://osemosys-playground/cplex/cplex_studio128.linux-x86-64.bin" cplex_studio128.linux-x86-64.bin
chmod +x cplex_studio128.linux-x86-64.bin
sudo ./cplex_studio128.linux-x86-64.bin 
# ...go through installation
sudo ln -s /opt/ibm/ILOG/CPLEX_Studio128/cplex/bin/x86-64_linux/cplex /usr/bin/cplex
rm cplex_studio128.linux-x86-64.bin

# Install GLPK
# https://en.wikibooks.org/wiki/GLPK/Linux_OS
wget ftp://ftp.gnu.org/gnu/glpk/glpk-4.55.tar.gz
tar -xzvf glpk-4.55.tar.gz
cd glpk-4.55
./configure
make
sudo make install
make clean
cd ..
rm -rf glpk-4.55*

# Add to bashrc:
# Values from heroku run printenv
echo 'export RAILS_ENV=production' >> ~/.bashrc
echo 'export RACK_ENV=production' >> ~/.bashrc
echo 'export DATABASE_URL=' >> ~/.bashrc
echo 'export RAILS_MASTER_KEY=' >> ~/.bashrc

# Setup repo
git clone https://github.com/yboulkaid/osemosys-cloud.git
cd osemosys-cloud/

bundle install --without development test

# Clear bash history
history -w
history -c

# Everything above here should be in the AMI
cd osemosys-cloud && bundle exec rake solve_run[2] && sudo shutdown -h now

# To solve cplex model:
glpsol -m osemosys.txt -d data.txt --wlp input.lp
# Maybe zip and upload lp file?
cplex -c 'read input.lp' 'optimize' 'write output.sol'
# Upload output.sol and cplex.log
