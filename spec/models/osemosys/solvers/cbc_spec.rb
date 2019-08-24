require 'rails_helper'

RSpec.describe Osemosys::Solvers::Cbc do
  context 'with a model and data' do
    it 'solves the model with glpsol and cbc' do
      run = create(:run, :queued)
      atlantis_model_path = "#{Rails.root}/spec/data/atlantis_model.txt"
      atlantis_data_path = "#{Rails.root}/spec/data/atlantis_data.txt"

      expect(run.state).to eq('queued')
      allow(run).to receive(:transition_to!).with(:generating_matrix).and_call_original
      allow(run).to receive(:transition_to!).with(:finding_solution).and_call_original

      output_file = Osemosys::Solvers::Cbc.new(
        local_model_path: atlantis_model_path,
        local_data_path: atlantis_data_path,
        run: run,
      ).call

      expect(output_file).to match(%r{\.\/data\/output.+\.zip})
      expect(run.state).to eq('finding_solution')
      expect(run).to have_received(:transition_to!).with(:generating_matrix)
      expect(run).to have_received(:transition_to!).with(:finding_solution)
    end
  end
end
