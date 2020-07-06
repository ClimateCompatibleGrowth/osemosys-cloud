# typed: false
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
  end

  it 'redirects to root for non signed in users' do
    user = create(:user)
    visit user_path(user)
    expect(page).not_to have_content('My User Profile')
    expect(page).to have_current_path('/')
  end

  it 'redirects to root for other users' do
    user = create(:user)
    other_user = create(:user)
    sign_in(user)
    visit user_path(other_user)
    expect(page).not_to have_content('My User Profile')
    expect(page).to have_current_path('/runs')
  end
end
