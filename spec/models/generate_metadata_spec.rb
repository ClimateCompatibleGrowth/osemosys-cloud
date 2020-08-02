require 'rails_helper'

RSpec.describe GenerateMetadata do
  it 'writes a json file and returns its path' do
    version = create(:version, name: 'My version')
    run = create(:run, name: 'A run', description: 'A description', version: version)

    json_file_path = GenerateMetadata.call(run: run)

    file_contents = File.read(json_file_path)
    contents = JSON.parse(file_contents, symbolize_names: true)
    expect(contents).to eq(
      run_name: 'A run',
      version_name: 'My version',
      description: 'A description',
    )
  end
end
