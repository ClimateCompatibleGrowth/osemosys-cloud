class ApplicationRenderer
  def self.render(**args)
    new.render(**args)
  end

  def render(**args)
    ApplicationController.renderer.new(
      http_host: host,
      https: Rails.env.production?,
    ).render(**args)
  end

  private

  def host
    if Rails.env.development?
      'http://localhost:3000'
    elsif Rails.env.test?
      'example.org'
    elsif Rails.env.production?
      'osemosys-cloud.com'
    end
  end
end
