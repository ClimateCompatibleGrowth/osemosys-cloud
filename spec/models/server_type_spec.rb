require 'rails_helper'

RSpec.describe ServerType do
  describe '.to_enum_definition' do
    it 'is the list of all types as an enum definition' do
      expect(ServerType.to_enum_definition).to eq(
        'sidekiq' => 'sidekiq',
        'z1d.3xlarge' => 'z1d.3xlarge',
      )
    end
  end

  describe '.from_slug' do
    it 'finds the right ServerType' do
      server_type = ServerType.from_slug('z1d.3xlarge')

      expect(server_type.name).to eq('Large server')
    end
  end

  it 'has translations for all server types' do
    ServerType.all.each do |server_type|
      expect(I18n.exists?(server_type.i18n_key, I18n.locale)).to be(true)
    end
  end
end
