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

  describe '#ec2?' do
    it 'is true when the server type is an EC2 instance' do
      run = build(:run, :ec2)

      expect(run.ec2?).to be(true)
    end

    it 'is false when the server type is sidekiq' do
      run = build(:run, :sidekiq)

      expect(run.ec2?).to be(false)
    end
  end

  describe '#sidekiq?' do
    it 'is true when the server type is an sidekiq instance' do
      run = build(:run, :sidekiq)

      expect(run.sidekiq?).to be(true)
    end

    it 'is false when the server type is sidekiq' do
      run = build(:run, :ec2)

      expect(run.sidekiq?).to be(false)
    end
  end
end
