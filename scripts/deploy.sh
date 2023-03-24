#!/bin/bash

set -xue

git reset --hard
git pull || true
bundle install
pip3 install -r requirements.txt
sudo systemctl restart osemosys-cloud-sidekiq.service
exit
