require_relative 'boot'
ENV['RANSACK_FORM_BUILDER'] = '::SimpleForm::FormBuilder'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OsemosysCloud
  class Application < Rails::Application
    config.lograge.enabled = true
    config.time_zone = 'Europe/Stockholm'

    config.load_defaults 6.0

    config.active_job.queue_adapter = :sidekiq

    config.i18n.available_locales = %i[en es]
    config.i18n.default_locale = :en
    config.i18n.fallbacks = { es: :en }
  end
end
