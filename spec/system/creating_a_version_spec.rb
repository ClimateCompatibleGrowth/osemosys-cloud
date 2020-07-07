require 'rails_helper'

RSpec.describe 'Creating a version and a run', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'works for logged in users' do
    sign_in(User.create!(email: 'test@example.com', password: 'blehbleh'))
    visit root_path

    click_on 'New version'

    fill_in 'Name', with: 'My version 123'
    click_on 'Create version'

    expect(page).to have_text('Run version created')
    expect(page).to have_text('My version 123')

    click_on('My version 123')

    expect(page).to have_text('My version 123')
    expect(page).to have_text('New run')
  end
end
