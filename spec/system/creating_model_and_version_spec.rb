require 'rails_helper'

RSpec.describe 'Creating a model, version and a run', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'allows creating, editing and deleting models' do
    sign_in(create(:user))
    visit root_path

    click_on 'New model'

    fill_in 'Name', with: 'My model 123'
    click_on 'Create model'

    expect(page).to have_text('Model created')
    expect(page).to have_text('My model 123')

    visit models_path

    click_on 'Edit'

    expect(page).to have_text('Update model')

    fill_in 'Name', with: 'My model 456'

    click_on 'Update model'

    expect(page).to have_text('Model updated')
    expect(page).to have_text('My model 456')

    visit models_path

    click_on 'New model'

    fill_in 'Name', with: 'My model to be deleted'
    click_on 'Create model'

    visit models_path
    model = Model.last

    within("[data-test-model-id=#{model.id}]") do
      click_on 'Edit'
    end
    click_on 'Delete'

    expect(page).to have_text('Model deleted')
    expect(page).not_to have_text('My model to be deleted')
  end

  it 'allows creating, editing and deleting versions' do
    user = create(:user)
    sign_in(user)
    model = create(:model, user: user)

    visit(model_path(model))

    click_on 'New version'

    fill_in 'Name', with: 'My version 123'
    click_on 'Create version'

    expect(page).to have_text('Run version created')
    expect(page).to have_text('My version 123')
    expect(page).to have_text('New run')

    visit(model_path(model))

    click_on 'Edit'

    expect(page).to have_text('Update version')

    fill_in 'Name', with: 'My version 456'

    click_on 'Update version'

    expect(page).to have_text('version updated')
    expect(page).to have_text('My version 456')

    click_on 'New version'

    fill_in 'Name', with: 'My version to be deleted'
    click_on 'Create version'

    visit(model_path(model))
    version = Version.last

    within("[data-test-version-id=#{version.id}]") do
      click_on 'Edit'
    end
    click_on 'Delete'

    expect(page).to have_text('version deleted')
    expect(page).not_to have_text('My version to be deleted')
  end

  it 'gracefully handles invalid urls' do
    sign_in(create(:user))

    visit(model_path(id: 3))

    expect(page).to have_text('Page not found')

    visit(version_path(id: 3))

    expect(page).to have_text('Page not found')
  end
end
