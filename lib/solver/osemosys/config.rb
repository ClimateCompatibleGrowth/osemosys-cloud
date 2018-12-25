module Osemosys
  class Config
    extend Dry::Configurable

    setting :run_id, Time.now.strftime('%Y-%m-%d_%H-%M-%S'), reader: true

    setting :logger, Logger.new($stdout), reader: true
    setting :s3_bucket, 'osemosys-playground', reader: true
  end
end
