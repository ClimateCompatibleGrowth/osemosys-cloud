#bin/sh

# Don't set -e, or the machines won't stop on failure!
# set -e

# https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -xu

run_id=$1
shutdown_on_finish=$2

cd /home/ubuntu/osemosys-cloud/ || exit
/home/ubuntu/.asdf/shims/bundle install
pip3 install -r requirements.txt

/home/ubuntu/.asdf/shims/bundle exec rake solve_cbc_run[$run_id]

if $shutdown_on_finish; then
  # echo "Shutting down"
  sudo shutdown -h now
fi
