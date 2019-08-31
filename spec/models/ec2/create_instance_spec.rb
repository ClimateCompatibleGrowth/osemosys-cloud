require 'rails_helper'

RSpec.describe Ec2::CreateInstance do
  it 'spawns the instance' do
    run = create(:run)
    instance = double(
      'Instance',
      id: 'abc',
      load: double(
        'Instance',
        public_ip_address: '127.0.0.1',
      ),
    )
    resource_double = double(
      'Resource',
      client: double(
        'Client',
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
    instance = double(
      'Instance',
      id: 'abc',
      load: double(
        'Instance',
        public_ip_address: '127.0.0.1',
      ),
    )
    resource_double = double(
      'Resource',
      client: double(
        'Client',
        wait_until: nil,
      ),
    )
    allow(Aws::EC2::Resource).to receive(:new).and_return resource_double
    allow(resource_double).to receive(:create_instances).and_return([instance])

    Ec2::CreateInstance.call(run_id: run.id, instance_type: 'my_type')

    expect(Ec2::Instance.count).to eq(1)
    created_instance = Ec2::Instance.last
    expect(created_instance.started_at).to be_past
    expect(created_instance.run_id).to eq(run.id)
    expect(created_instance.ip).to eq('127.0.0.1')
  end
end
