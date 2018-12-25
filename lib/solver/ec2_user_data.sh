sudo yum install git rubygem-json
# install rvm https://medium.com/@khandelwal12nidhi/installation-of-ruby-on-rails-on-aws-ec2-linux-50af3ca3c50f
gem install bundler
git clone https://github.com/yboulkaid/OSeMOSYS.git
cd OSeMOSYS/script/ruby
bundle

# Everything above here should be in the AMI

bundle exec bin/solve --s3-model 'ruby_trial/my-ec2-run/input/model/osemosys.txt' --s3-data 'ruby_trial/my-ec2-run/input/data/data.txt' --run-id my-ec2-run
