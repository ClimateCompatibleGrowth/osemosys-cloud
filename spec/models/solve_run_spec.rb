require 'rails_helper'

RSpec.describe SolveRun do
  describe '#call' do
    it 'transitions the run to succeeded' do
      run = create(:run, :queued, :atlantis)
      expect(run.state).to eq('queued')

      SolveRun.new(run: run, solver: Osemosys::Solvers::Dummy, logger: Logger.new($stdout)).call

      expect(run.state).to eq('succeeded')
    end

    xit 'triggers the run solving' do
    end

    xit 'saves the result file' do
    end

    it 'performs the after finish hook' do
      run = create(:run, :queued, :atlantis)
      allow(AfterFinishHook).to receive(:new).with(run: run).and_return(
        instance_double('AfterFinishHook', call: 'OK'),
      )

      SolveRun.new(run: run, solver: Osemosys::Solvers::Dummy, logger: Logger.new($stdout)).call

      expect(AfterFinishHook).to have_received(:new).once
    end

    context 'when an exception is raised' do
      it 'still performs the after finish hook' do
        run = create(:run, :faulty)
        allow(AfterFinishHook).to receive(:new).with(run: run).and_return(
          instance_double('AfterFinishHook', call: 'OK'),
        )

        expect do
          SolveRun.new(run: run, solver: Osemosys::Solvers::Dummy, logger: Logger.new($stdout)).call
        end.to raise_error(TTY::Command::ExitError)
        expect(AfterFinishHook).to have_received(:new).once
      end
    end

    describe 'timeout' do
      it 'times out when the run takes longer than expected' do
        run = create(:run, :queued, :atlantis)
        allow(run).to receive(:timeout).and_return(1.second)
        Osemosys::Config.config.dummy_solver_sleep_duration = 2.seconds
        allow(AfterFinishHook).to receive(:new).with(run: run).and_return(
          instance_double('AfterFinishHook', call: 'OK'),
        )

        expect do
          SolveRun.new(run: run, solver: Osemosys::Solvers::Dummy, logger: Logger.new($stdout)).call
        end.to raise_error(Timeout::Error)
        expect(AfterFinishHook).to have_received(:new).once
      end
    end
  end
end
