require 'rails_helper'

RSpec.describe SolveRun do
  describe '#call' do
    context 'when missing the model or data file' do
      it 'raises an error' do
        run = create(:run)

        expect { SolveRun.new(run: run).call }.to raise_error(
          SolveRun::NoModelOrDataFile,
        )
      end
    end

    it 'sets started_at on the run' do
      run = create(:run, :atlantis)
      expect(run.started_at).to be nil

      SolveRun.new(run: run).call

      expect(run.started_at).to be_past
    end

    xit 'triggers the run solving' do
    end

    xit 'saves the result file' do
    end

    it 'performs the after finish hook' do
      run = create(:run, :atlantis)
      allow(AfterFinishHook).to receive(:new).with(run: run).and_return(
        instance_double('AfterFinishHook', call: 'OK'),
      )

      SolveRun.new(run: run).call

      expect(AfterFinishHook).to have_received(:new).once
    end

    context 'when an exception is raised' do
      it 'still performs the after finish hook' do
        run = create(:run, :faulty)
        allow(AfterFinishHook).to receive(:new).with(run: run).and_return(
          instance_double('AfterFinishHook', call: 'OK'),
        )

        expect { SolveRun.new(run: run).call }.to raise_error(
          TTY::Command::ExitError,
        )

        expect(AfterFinishHook).to have_received(:new).once
      end
    end
  end
end
