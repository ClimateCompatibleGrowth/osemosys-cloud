class ServerType
  def self.all
    [
      new(name: 'Small server', slug: 'sidekiq', i18n_key: 'server_type.small'),
      new(name: 'Large server', slug: 'z1d.3xlarge', i18n_key: 'server_type.large'),
    ].freeze
  end

  def self.to_enum_definition
    all.map do |server_type|
      { server_type.slug => server_type.slug }
    end.inject(:merge)
  end

  def self.from_slug(slug)
    all.find { |server_type| server_type.slug == slug }
  end

  def initialize(name:, slug:, i18n_key:)
    @name = name
    @slug = slug
    @i18n_key = i18n_key
  end

  def name
    I18n.t(i18n_key)
  end

  attr_reader :slug, :i18n_key
end
