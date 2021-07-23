require 'rails_helper'

RSpec.describe Ec2::InstanceParams do
  describe 'to_h' do
    it 'passes the instance_type param' do
      params = Ec2::InstanceParams.new(instance_type: 'my-instance-type', run_id: 1).to_h
      expect(params[:instance_type]).to eq('my-instance-type')
    end
  end
end
