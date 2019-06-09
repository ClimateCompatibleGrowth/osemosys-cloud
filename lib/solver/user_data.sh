#bin/sh

# set -e
set -x

run_id=$1

if [[ $1 == "" ]] ; then
  echo 'Pass the run_id as an argument'
  exit 0
fi

sudo service docker start
docker pull yboulkaid/osemosys 
mkdir data 
docker run \
  -e RAILS_ENV=production \
  -e DATABASE_URL \
  -e RAILS_MASTER_KEY \
  -v /tmp:/tmp \
  -v /home/ec2-user/data:/osemosys-cloud/data \
  yboulkaid/osemosys \
  bundle exec rake solve_cbc_run[$run_id]

sudo shutdown -h now
