require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OsemosysCloud
  class Application < Rails::Application
    config.time_zone = 'Europe/Stockholm'

    config.load_defaults 5.2
  end
end
