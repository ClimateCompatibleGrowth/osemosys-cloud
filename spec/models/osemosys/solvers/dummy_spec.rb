require 'rails_helper'

RSpec.describe Osemosys::Solvers::Dummy do
  context 'with a model with non zero size' do
    it 'returns a dummy path' do
      run = create(:run, :queued)
      atlantis_model_path = "#{Rails.root}/spec/data/atlantis_model.txt"
      atlantis_data_path = "#{Rails.root}/spec/data/atlantis_data.txt"

      expect(run.state).to eq('queued')
      allow(run).to receive(:transition_to!).with(:generating_matrix).and_call_original
      allow(run).to receive(:transition_to!).with(:finding_solution).and_call_original

      output_file = Osemosys::Solvers::Dummy.new(
        local_model_path: atlantis_model_path,
        local_data_path: atlantis_data_path,
        run: run,
      ).call

      expect(output_file).to eq('/dev/null')
      expect(run.state).to eq('finding_solution')
      expect(run).to have_received(:transition_to!).with(:generating_matrix)
      expect(run).to have_received(:transition_to!).with(:finding_solution)
    end
  end

  context 'with an empty file size (dummy input)' do
    it 'raises a TTY::Command::ExitError' do
      run = create(:run, :queued)
      empty_file_path = "#{Rails.root}/spec/data/empty_file.txt"

      expect do
        Osemosys::Solvers::Dummy.new(
          local_model_path: empty_file_path,
          local_data_path: empty_file_path,
          run: run,
        ).call
      end.to raise_error(TTY::Command::ExitError)
    end
  end

  describe 'sleep_duration' do
    context 'with no sleep duration' do
      it 'is instant' do
        run = create(:run, :queued)
        atlantis_model_path = "#{Rails.root}/spec/data/atlantis_model.txt"
        atlantis_data_path = "#{Rails.root}/spec/data/atlantis_data.txt"

        start_time = Time.now
        Osemosys::Solvers::Dummy.new(
          local_model_path: atlantis_model_path,
          local_data_path: atlantis_data_path,
          run: run,
        ).call
        end_time = Time.now

        expect(end_time - start_time).to be < 0.1
      end
    end

    context 'with a sleep duration' do
      it 'is instant' do
        run = create(:run, :queued)
        atlantis_model_path = "#{Rails.root}/spec/data/atlantis_model.txt"
        atlantis_data_path = "#{Rails.root}/spec/data/atlantis_data.txt"

        start_time = Time.now
        Osemosys::Solvers::Dummy.new(
          local_model_path: atlantis_model_path,
          local_data_path: atlantis_data_path,
          run: run,
          sleep_duration: 0.5,
        ).call
        end_time = Time.now

        expect(end_time - start_time).to be_within(0.1).of(0.5)
      end
    end
  end
end
