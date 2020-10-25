require 'rails_helper'

RSpec.describe GenerateMetadata do
  it 'writes a json file and returns its path' do
    model = create(:model, name: 'Ethiopia 2020')
    version = create(:version, name: 'My version', model: model)
    run = create(
      :run,
      name: 'A run',
      description: 'A description',
      version: version,
      language: 'es',
    )

    json_file_path = GenerateMetadata.call(run: run)

    file_contents = File.read(json_file_path)
    contents = JSON.parse(file_contents, symbolize_names: true)
    expect(contents).to eq(
      description: 'A description',
      model_name: 'Ethiopia 2020',
      run_name: 'A run',
      version_name: 'My version',
      language: 'es',
    )
  end
end
