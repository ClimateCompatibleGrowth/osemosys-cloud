require 'dry/configurable/test_interface'

module Osemosys
  class Config
    extend Dry::Configurable
    enable_test_interface

    setting :run_id, Time.now.strftime('%Y-%m-%d_%H-%M-%S'), reader: true

    setting :s3_bucket, 'osemosys-cloud-development', reader: true
    setting :dummy_solver_sleep_duration, 0, reader: true
  end
end
