require 'rails_helper'

RSpec.describe Commands::PreprocessDataFile do
  it 'runs the python script' do
    input_file_path = Rails.root.join('spec', 'data', 'atlantis_data.txt')
    ouput_file_path = Rails.root.join('spec', 'data', 'atlantis_data_preprocessed.txt')
    model_file_path = Rails.root.join('spec', 'data', 'atlantis_model.txt')
    preprocessed_model_file_path = Rails.root.join('spec', 'data', 'atlantis_model.pre.txt')

    expect(File.exist?(ouput_file_path)).to be false
    expect(File.exist?(preprocessed_model_file_path)).to be false

    Commands::PreprocessDataFile.new(
      local_data_path: input_file_path,
      preprocessed_data_path: ouput_file_path,
      model_file_path: model_file_path,
      preprocessed_model_file_path: preprocessed_model_file_path,
      logger: Logger.new($stdout),
    ).call

    expect(File.exist?(ouput_file_path)).to be true
    expect(File.exist?(preprocessed_model_file_path)).to be true
    File.delete(ouput_file_path)
    File.delete(preprocessed_model_file_path)
  end
end
