require 'rails_helper'

RSpec.describe 'Viewing the admin stats', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'works for admin in users' do
    sign_in(create(:user, :admin))
    visit admin_stats_path
    expect(page).to have_content('Stats')
    expect(page).to have_current_path('/admin/stats')
  end

  it 'redirects to root for non admin users' do
    sign_in(create(:user))
    visit admin_stats_path
    expect(page).not_to have_content('Stats')
    expect(page).to have_current_path('/runs')
  end

  it 'redirects to root for non signed in users' do
    visit admin_stats_path
    expect(page).not_to have_content('Stats')
    expect(page).to have_current_path('/')
  end
end
