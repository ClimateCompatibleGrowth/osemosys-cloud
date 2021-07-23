#bin/sh

# set -e

# https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -xu

run_id=$1
shutdown_on_finish=$2

cd osemosys-cloud/ || exit
git reset --hard HEAD
git pull
bundle install
pip3 install -r requirements.txt

bundle exec rake solve_cbc_run[$run_id]

if $shutdown_on_finish; then
  # echo "Shutting down"
  sudo shutdown -h now
fi
