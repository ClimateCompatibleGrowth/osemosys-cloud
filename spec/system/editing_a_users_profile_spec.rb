require 'rails_helper'

RSpec.describe 'Editing my profile', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'works for logged in users' do
    user = create(:user)
    sign_in(user)
    visit user_path(user)
    expect(page).to have_content 'My User Profile'
    expect(page).to have_content user.email
    # Re-comment those lines when we have a spanish translation
    # select('Spanish', from: 'Language')
    uncheck('user_runs_visible_to_admins')
    click_on('Update User')
    expect(page).to have_content('User updated')
    user.reload
    # expect(user.locale).to eq('es')
    expect(user.runs_visible_to_admins).to be(false)
  end

  it 'redirects to root for non signed in users' do
    user = create(:user)
    visit user_path(user)
    expect(page).not_to have_content('My User Profile')
    expect(page).to have_current_path('/users/sign_in')
  end

  it 'redirects to root for other users' do
    user = create(:user)
    other_user = create(:user)
    sign_in(user)
    visit user_path(other_user)
    expect(page).not_to have_content('My User Profile')
    expect(page).to have_current_path('/models')
  end
end
