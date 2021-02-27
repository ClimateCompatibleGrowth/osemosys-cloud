Sidekiq.configure_server do |config|
  config.redis = { url: OsemosysCloud::Redis.redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: OsemosysCloud::Redis.redis_url }
end
