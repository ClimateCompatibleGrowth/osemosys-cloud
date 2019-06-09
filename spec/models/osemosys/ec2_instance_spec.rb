require 'rails_helper'

RSpec.describe Osemosys::Ec2Instance do
  describe '#instance_params' do
    context 'when the instance type supports cpu options' do
      it 'includes cpu options' do
        instance = Osemosys::Ec2Instance.new(run_id: 1, instance_type: 'c5.9xlarge')
        expect(instance.instance_params).to include(:cpu_options)
      end
    end

    context 'when the instance type does not support cpu options' do
      it 'does not include cpu options' do
        instance = Osemosys::Ec2Instance.new(run_id: 1, instance_type: 't2.micro')
        expect(instance.instance_params).not_to include(:cpu_options)
      end
    end
  end
end
