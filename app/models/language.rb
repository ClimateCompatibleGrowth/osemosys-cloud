class Language
  def self.all
    [
      new(name: 'English', slug: 'en'),
      new(name: 'Spanish', slug: 'es'),
    ].freeze
  end

  def self.to_enum_definition
    all.map do |language|
      { language.slug => language.slug }
    end.inject(:merge)
  end

  def self.from_slug(slug)
    all.find { |language| language.slug == slug }
  end

  def initialize(name:, slug:)
    @name = name
    @slug = slug
  end

  attr_reader :name, :slug
end
