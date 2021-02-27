module OsemosysCloud
  class Redis
    def self.redis_url
      "redis://#{redis_endpoint}/#{database_number}"
    end

    def self.redis_endpoint
      if Rails.env.production?
        Rails.application.credentials.dig(:redis_cloud, :endpoint)
      else
        '127.0.0.1:6379'
      end
    end

    def self.database_number
      if Rails.env.production?
        0
      else
        1
      end
    end
  end
end
