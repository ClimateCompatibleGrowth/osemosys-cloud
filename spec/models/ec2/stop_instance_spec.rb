require 'rails_helper'

RSpec.describe Ec2::StopInstance do
  it 'stops the instance' do
    create(:ec2_instance, aws_id: 'abc')
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
end
