require 'rails_helper'

RSpec.describe EnqueueRunSolverJob do
  context 'when running in production' do
    it 'runs on EC2 for runs set to run on EC2' do
      run = create(:run, :ec2)
      allow(Rails.env).to receive(:production?).and_return true
      allow(Ec2::CreateInstance).to receive(:call)
      allow(SolveRunJob).to receive(:perform_later)

      EnqueueRunSolverJob.new.perform(run_id: run.id)

      expect(Ec2::CreateInstance).to have_received(:call).with(
        run_id: run.id, instance_type: 'z1d.3xlarge',
      )
      expect(SolveRunJob).not_to have_received(:perform_later)
    end

    it 'runs inline for runs set to run on sidekiq' do
      run = create(:run, :sidekiq)
      allow(Rails.env).to receive(:production?).and_return true
      allow(Ec2::CreateInstance).to receive(:call)
      allow(SolveRunJob).to receive(:perform_later)

      EnqueueRunSolverJob.new.perform(run_id: run.id)

      expect(SolveRunJob).to have_received(:perform_later).with(
        run_id: run.id,
      )
      expect(Ec2::CreateInstance).not_to have_received(:call)
    end
  end

  context 'when running in development or test' do
    it 'runs inline for runs set to run on EC2' do
      run = create(:run, :ec2)
      allow(Ec2::CreateInstance).to receive(:call)
      allow(SolveRunJob).to receive(:perform_later)

      EnqueueRunSolverJob.new.perform(run_id: run.id)

      expect(SolveRunJob).to have_received(:perform_later).with(
        run_id: run.id,
      )
      expect(Ec2::CreateInstance).not_to have_received(:call)
    end

    it 'runs inline for runs set to run on sidekiq' do
      run = create(:run, :sidekiq)
      allow(Ec2::CreateInstance).to receive(:call)
      allow(SolveRunJob).to receive(:perform_later)

      EnqueueRunSolverJob.new.perform(run_id: run.id)

      expect(SolveRunJob).to have_received(:perform_later).with(
        run_id: run.id,
      )
      expect(Ec2::CreateInstance).not_to have_received(:call)
    end
  end
end
