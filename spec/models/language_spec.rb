require 'rails_helper'

RSpec.describe Language do
  describe '.to_enum_definition' do
    it 'is the list of all types as an enum definition' do
      expect(Language.to_enum_definition).to eq(
        'en' => 'en',
        'es' => 'es',
      )
    end
  end

  describe '.from_slug' do
    it 'finds the right Language' do
      language = Language.from_slug('es')

      expect(language.name).to eq('Spanish')
    end
  end

  it 'has translations for all server types' do
    Language.all.each do |server_type|
      expect(I18n.exists?(server_type.i18n_key, I18n.locale)).to be(true)
    end
  end
end
