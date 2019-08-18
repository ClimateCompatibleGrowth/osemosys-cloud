require 'rails_helper'

RSpec.describe Ec2::InstanceParams do
  describe 'to_h' do
    it 'passes the instance_type param' do
      params = Ec2::InstanceParams.new(instance_type: 'my-instance-type', run_id: 1).to_h
      expect(params[:instance_type]).to eq('my-instance-type')
    end

    context 'when the instance type supports cpu options' do
      it 'includes cpu options' do
        params = Ec2::InstanceParams.new(instance_type: 'c5.9xlarge', run_id: 1).to_h
        expect(params).to include(:cpu_options)
      end
    end

    context 'when the instance type does not support cpu options' do
      it 'does not include cpu options' do
        params = Ec2::InstanceParams.new(instance_type: 't2.micro', run_id: 1).to_h
        expect(params).not_to include(:cpu_options)
      end
    end
  end
end
