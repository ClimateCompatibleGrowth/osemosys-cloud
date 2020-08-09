#!/bin/bash

set -xue

git reset --hard
git pull
bundle install
sudo systemctl restart osemosys-cloud-sidekiq.service
exit
