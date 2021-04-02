require 'rails_helper'

RSpec.describe Ec2::StopInstance do
  it 'stops the instance' do
    run = create(:run, :ongoing)
    create(:ec2_instance, run: run, aws_id: 'abc')
    instance = instance_double(
      'Instance',
      id: 'abc',
    )
    resource_double = instance_double('Aws::EC2::Resource')
    allow(Aws::EC2::Resource).to receive(:new).and_return resource_double
    allow(resource_double).to receive(:instance).with('abc').and_return instance
    allow(instance).to receive(:terminate)

    Ec2::StopInstance.call(aws_id: 'abc')

    expect(instance).to have_received(:terminate)
  end

  it 'sets the run as failed' do
    run = create(:run, :ongoing)
    create(:ec2_instance, run: run, aws_id: 'abc')
    instance = instance_double('Instance', id: 'abc')
    resource_double = instance_double('Aws::EC2::Resource')
    allow(Aws::EC2::Resource).to receive(:new).and_return resource_double
    allow(resource_double).to receive(:instance).with('abc').and_return instance
    allow(instance).to receive(:terminate)

    Ec2::StopInstance.call(aws_id: 'abc')

    expect(run.reload.state).to eq('failed')
  end

  it 'sets stopped_at on the instance' do
    run = create(:run, :ongoing)
    ec2_instance = create(:ec2_instance, run: run, aws_id: 'abc')
    instance = instance_double('Instance', id: 'abc')
    resource_double = instance_double('Aws::EC2::Resource')
    allow(Aws::EC2::Resource).to receive(:new).and_return resource_double
    allow(resource_double).to receive(:instance).with('abc').and_return instance
    allow(instance).to receive(:terminate)

    Ec2::StopInstance.call(aws_id: 'abc')

    expect(ec2_instance.reload.stopped_at).to be_past
  end

  it 'handles when the run is already failed' do
    run = create(:run, :ongoing)
    run.transition_to! :failed
    _ec2_instance = create(:ec2_instance, run: run, aws_id: 'abc')
    instance = instance_double('Instance', id: 'abc')
    resource_double = instance_double('Aws::EC2::Resource')
    allow(Aws::EC2::Resource).to receive(:new).and_return resource_double
    allow(resource_double).to receive(:instance).with('abc').and_return instance
    allow(instance).to receive(:terminate)

    Ec2::StopInstance.call(aws_id: 'abc')

    expect(run.state).to eq('failed')
  end
end
