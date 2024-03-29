require 'dry/configurable/test_interface'

module Osemosys
  class Config
    extend Dry::Configurable
    enable_test_interface

    setting :s3_bucket, default: 'osemosys-cloud-production', reader: true
    setting :dummy_solver_sleep_duration, default: 0, reader: true
  end
end
