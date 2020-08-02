class ServerType
  def self.all
    [
      new(name: 'Small server', slug: 'sidekiq'),
      new(name: 'Large server', slug: 'z1d.3xlarge'),
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

  def initialize(name:, slug:)
    @name = name
    @slug = slug
  end

  attr_reader :name, :slug
end
