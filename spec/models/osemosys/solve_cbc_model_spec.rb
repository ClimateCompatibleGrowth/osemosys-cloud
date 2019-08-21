require 'rails_helper'

RSpec.describe Osemosys::SolveCbcModel do
  context 'with a model and data' do
    it 'solves the model with glpsol' do
      atlantis_model_path = "#{Rails.root}/spec/data/atlantis_model.txt"
      atlantis_data_path = "#{Rails.root}/spec/data/atlantis_data.txt"

      output_file = Osemosys::SolveCbcModel.new(
        local_model_path: atlantis_model_path,
        local_data_path: atlantis_data_path,
      ).call

      expect(output_file).to eq('./data/output.zip')
    end
  end
end
