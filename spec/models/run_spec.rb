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
end
