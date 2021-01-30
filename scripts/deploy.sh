#!/bin/bash

set -xue

git reset --hard
git pull
bundle install
pip install -r requirements.txt
sudo systemctl restart osemosys-cloud-sidekiq.service
exit
