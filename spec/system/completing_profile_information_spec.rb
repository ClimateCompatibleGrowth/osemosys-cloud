require 'rails_helper'

RSpec.describe 'Completing your profile information', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'works for logged in users' do
    user = create(:user)
    user.name = ''
    user.save(validate: false)

    sign_in(user)
    visit models_path

    expect(page).to have_text('Please fill in your profile information to continue.')
    fill_in :name, with: 'Jane Doe'
    click_on 'Update User'
    expect(page).to have_text('User updated')

    visit models_path
    expect(page).to have_text('My models')
  end
end
