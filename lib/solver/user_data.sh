#bin/sh

# set -e

# https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -xu

run_id=$1
shutdown_on_finish=$2

sudo service docker start
docker pull yboulkaid/osemosys 
mkdir data 
docker run \
  -e RAILS_ENV=production \
  -e DATABASE_URL \
  -e RAILS_MASTER_KEY \
  -v /tmp:/tmp \
  -v /home/ec2-user/data:/osemosys-cloud/data \
  yboulkaid/osemosys \
  bundle exec rake solve_cbc_run[$run_id]

if $shutdown_on_finish; then
  # echo "Shutting down"
  sudo shutdown -h now
fi
