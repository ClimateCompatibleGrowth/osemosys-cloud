require 'rails_helper'

RSpec.describe Language do
  describe '.to_enum_definition' do
    it 'is the list of all types as an enum definition' do
      expect(Language.to_enum_definition).to eq(
        'English' => 'en',
        'Spanish' => 'es',
      )
    end
  end

  describe '.from_slug' do
    it 'finds the right Language' do
      language = Language.from_slug('es')

      expect(language.name).to eq('Spanish')
    end
  end
end
