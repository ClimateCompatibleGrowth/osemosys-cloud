class Language
  def self.all
    [
      new(slug: 'en', i18n_key: 'language.en'),
      new(slug: 'es', i18n_key: 'language.es'),
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

  def initialize(slug:, i18n_key:)
    @slug = slug
    @i18n_key = i18n_key
  end

  def name
    I18n.t(i18n_key)
  end

  attr_reader :slug, :i18n_key
end
