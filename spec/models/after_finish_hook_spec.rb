# typed: false
require 'rails_helper'
require 'fileutils'

RSpec.describe AfterFinishHook do
  describe '#call' do
    context 'when the run has a result file attached' do
      it 'transitions to the succeeded state' do
        run = create(:run, :ongoing, :with_result)
        expect(run.state).to eq('finding_solution')

        AfterFinishHook.new(run: run).call

        expect(run.state).to eq('succeeded')
      end
    end

    context 'when the run has no result file attached' do
      it 'sets the outcome to failure' do
        run = create(:run, :ongoing)
        expect(run.state).to eq('finding_solution')

        AfterFinishHook.new(run: run).call

        expect(run.state).to eq('failed')
      end
    end

    context 'when a log file exists' do
      it 'uploads the log file' do
        run = create(:run, :ongoing)
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
        run = create(:run, :ongoing)
        expect(run.log_file).not_to be_attached

        AfterFinishHook.new(run: run).call

        expect(run.log_file).not_to be_attached
      end
    end

    context 'when there is an attached instance' do
      it 'sets stopped_at' do
        run = create(:run, :ongoing)
        ec2_instance = create(:ec2_instance, run: run)
        expect(ec2_instance.stopped_at).to be nil

        AfterFinishHook.new(run: run).call

        expect(ec2_instance.reload.stopped_at).to be_past
      end
    end

    context 'when the run is not set to notify when finished' do
      it 'does not send an email' do
        run = create(:run, :ongoing, notify_when_finished: false)

        AfterFinishHook.new(run: run).call
        perform_enqueued_jobs

        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end

    context 'when the run is set to notify when finished' do
      it 'sends an email' do
        run = create(:run, :ongoing, notify_when_finished: true)

        AfterFinishHook.new(run: run).call
        perform_enqueued_jobs

        expect(ActionMailer::Base.deliveries.count).to eq(1)
        sent_mail = ActionMailer::Base.deliveries.last
        expect(sent_mail.to).to include(run.user.email)
        expect(sent_mail.body).to include('Run finished: ')
      end
    end
  end
end
