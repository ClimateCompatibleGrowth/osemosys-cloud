TranslationIO.configure do |config|
  config.api_key        = Rails.application.credentials.dig(:translation, :api_key)
  config.source_locale  = 'en'
  config.target_locales = ['es']
  config.disable_gettext = true
end
