require 'rails_helper'

RSpec.describe 'Creating a run', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'works for logged in users' do
    user = create(:user)
    sign_in(user)
    version = create(:version, name: 'Ethopia 2014', user: user)
    visit version_path(version)

    expect(page).to have_text('Osemosys Cloud')

    click_on 'New run'

    fill_in 'Name', with: 'Atlantis'
    fill_in 'Description', with: 'A Place Long Gone'

    select('Large server', from: 'run_server_type')
    select('Spanish', from: 'run_language')

    atlantis_model = "#{Rails.root}/spec/data/atlantis_model.txt"
    atlantis_data = "#{Rails.root}/spec/data/atlantis_data.txt"

    attach_file 'run_model_file', atlantis_model
    attach_file 'run_data_file', atlantis_data

    click_on 'Create run'

    expect(page).to have_text 'Atlantis'
    expect(page).to have_text 'Run created'
    expect(page).to have_text 'A Place Long Gone'
    expect(page).to have_text 'Spanish'

    click_on 'Edit'

    fill_in 'Name', with: 'Eldorado'
    fill_in 'Description', with: 'A Wonderful place'
    select('English', from: 'run_language')
    click_on 'Update run'

    expect(page).to have_text 'Run updated'
    expect(page).to have_text 'Eldorado'
    expect(page).to have_text 'A Wonderful place'
    expect(page).to have_text 'English'

    click_on 'Edit'
    click_on 'Delete'

    expect(page).to have_text 'Run deleted'
    expect(page).not_to have_text 'Eldorado'
  end

  it 'redirects to root for logged out users' do
    visit root_path

    expect(page).to have_text('Sign in or register to start.')

    visit models_path

    expect(page).to have_text('You need to sign in or sign up before continuing.')
  end

  it 'renders not authorized for inactivated users' do
    user = create(:user, active: false)
    sign_in(user)
    visit root_path

    expect(page).to have_text('Not authorized')
  end
end
