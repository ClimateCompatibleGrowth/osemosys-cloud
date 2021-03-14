Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Json.new

  config.lograge.custom_options = lambda do |event|
    {
      app: ENV['HEROKU_APP_NAME'],
      dyno: ENV['DYNO'],
      host: event.payload[:host],
      ip: event.payload[:ip],
      locale: event.payload[:locale],
      params: event.payload[:params],
      request_id: event.payload[:request_id],
      timestamp: Time.zone.now,
      user: {
        id: event.payload[:user_id],
        email: event.payload[:user_email],
      },
    }.compact
  end
end
