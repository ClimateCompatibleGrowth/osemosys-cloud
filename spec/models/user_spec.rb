require 'rails_helper'

RSpec.describe User do
  describe '#complete_profile_information?' do
    it 'is true when name and country code are filled in' do
      user = build(:user)

      expect(user.complete_profile_information?).to be(true)
    end

    it 'is false when name is missing' do
      user = build(:user, name: nil)

      expect(user.complete_profile_information?).to be(false)
    end

    it 'is false when country is missing' do
      user = build(:user, country_code: nil)

      expect(user.complete_profile_information?).to be(false)
    end
  end
end
