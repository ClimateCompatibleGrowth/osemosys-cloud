require 'rails_helper'
require 'fileutils'

RSpec.describe AfterFinishHook do
  describe '#call' do
    it 'sets finished_at' do
      run = create(:run)
      expect(run.finished_at).to be nil

      AfterFinishHook.new(run: run).call

      expect(run.finished_at).to be_past
    end

    context 'when the run has a result file attached' do
      it 'sets the outcome to success' do
        run = create(:run, :with_result)
        expect(run.outcome).to be nil

        AfterFinishHook.new(run: run).call

        expect(run.outcome).to eq('success')
      end
    end

    context 'when the run has no result file attached' do
      it 'sets the outcome to failure' do
        run = create(:run)
        expect(run.outcome).to be nil

        AfterFinishHook.new(run: run).call

        expect(run.outcome).to eq('failure')
      end
    end

    context 'when a log file exists' do
      it 'uploads the log file' do
        run = create(:run)
        FileUtils.touch(
          Rails.root.join('tmp', run.local_log_path),
        )
        expect(run.log_file).not_to be_attached

        AfterFinishHook.new(run: run).call

        expect(run.log_file).to be_attached
      end
    end

    context 'when there is no log file' do
      it 'does not attach the log file' do
        run = create(:run)
        expect(run.log_file).not_to be_attached

        AfterFinishHook.new(run: run).call

        expect(run.log_file).not_to be_attached
      end
    end
  end
end
