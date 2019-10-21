require 'rails_helper'

RSpec.describe Ec2::CreateInstance do
  it 'spawns the instance' do
    run = create(:run)
    instance = instance_double(
      'Instance',
      id: 'abc',
      load: instance_double(
        'Aws::EC2::Instance',
        public_ip_address: '127.0.0.1',
        id: 'my-aws-id',
        instance_type: 't2.micro',
      ),
    )
    resource_double = instance_double(
      'Aws::EC2::Resource',
      client: instance_double(
        'Aws::EC2::Client',
        wait_until: nil,
      ),
    )
    allow(Aws::EC2::Resource).to receive(:new).and_return resource_double
    allow(resource_double).to receive(:create_instances).and_return([instance])

    Ec2::CreateInstance.call(run_id: run.id, instance_type: 'my_type')

    expect(resource_double).to have_received(:create_instances).with(
      hash_including(
        instance_type: 'my_type',
      ),
    )
  end

  it 'creates an Ec2::Instance' do
    run = create(:run)
    instance = instance_double(
      'Instance',
      id: 'abc',
      load: instance_double(
        'Aws::EC2::Instance',
        public_ip_address: '127.0.0.1',
        id: 'my-aws-id',
        instance_type: 't2.micro',
      ),
    )
    resource_double = instance_double(
      'Aws::EC2::Resource',
      client: instance_double(
        'Aws::EC2::Client',
        wait_until: nil,
      ),
    )
    allow(Aws::EC2::Resource).to receive(:new).and_return resource_double
    allow(resource_double).to receive(:create_instances).and_return([instance])

    Ec2::CreateInstance.call(run_id: run.id, instance_type: 't2.micro')

    expect(Ec2::Instance.count).to eq(1)
    created_instance = Ec2::Instance.last
    expect(created_instance.started_at).to be_past
    expect(created_instance.run_id).to eq(run.id)
    expect(created_instance.ip).to eq('127.0.0.1')
    expect(created_instance.instance_type).to eq('t2.micro')
    expect(created_instance.aws_id).to eq('my-aws-id')
  end
end
