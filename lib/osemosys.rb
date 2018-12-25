require 'aws-sdk-ec2'
require 'aws-sdk-s3'
require 'dry-configurable'
require 'slop'
require 'tty-command'

# Not necessary anymore since rails autoloads them
# but leaving them in case we want to extract a gem
require_relative 'osemosys/config'
require_relative 'osemosys/workfile'
require_relative 'osemosys/data_file'
require_relative 'osemosys/ec2_instance'
require_relative 'osemosys/model_file'
require_relative 'osemosys/output_file'
require_relative 'osemosys/prepare_model'
require_relative 'osemosys/solve_model'

# TODO: Save and upload logs

module Osemosys
  # require 'pry'; binding.pry
end
