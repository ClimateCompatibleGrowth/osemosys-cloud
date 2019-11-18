require 'rails_helper'

RSpec.describe Run do
  describe 'validations' do
    context 'when a run has post_processing but no pre_processing' do
      it 'is invalid' do
        run = build(:run, pre_process: false, post_process: true)

        expect(run).not_to be_valid
      end
    end

    context 'when a run has post_processing and pre_processing' do
      it 'is valid' do
        run = build(:run, pre_process: true, post_process: true)

        expect(run).to be_valid
      end
    end
  end
  describe '#solving_time' do
    context 'when the run has not been started' do
      it 'is nil' do
        run = build(:run)

        expect(run.solving_time).to be nil
      end
    end

    context 'when the run has not been finished' do
      it 'is nil' do
        run = build(:run, :ongoing)

        expect(run.solving_time).to be nil
      end
    end

    context 'when the run has started and finished' do
      it 'is the time difference between start and finish' do
        run = create(:run, :finished)
        run.history.first.update(created_at: 1.hour.ago)

        expect(run.solving_time).to be_within(1).of(3600)
      end
    end
  end
end
