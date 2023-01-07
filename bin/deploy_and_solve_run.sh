#bin/sh

# https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -exu

run_id=$1
shutdown_on_finish=$2

terminate_instance() {
  echo "Terminating instance now..."
  if $shutdown_on_finish; then
    sudo shutdown -h now
  fi
}

trap "terminate_instance" ERR

cd /home/ubuntu/osemosys-cloud/ || exit
/home/ubuntu/.asdf/shims/bundle install
pip3 install -r requirements.txt

/home/ubuntu/.asdf/shims/bundle exec rake solve_cbc_run[$run_id]

terminate_instance
