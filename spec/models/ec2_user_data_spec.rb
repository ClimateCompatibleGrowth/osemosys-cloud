require 'rails_helper'

RSpec.describe Osemosys::Ec2UserData do
  describe '#to_base64_encoded' do
    it 'is a base64 encoded text' do
      output = Osemosys::Ec2UserData.new(run_id: 1).to_base64_encoded

      decoded_output = Base64.decode64(output)

      expect(decoded_output).to include('#!/usr/bin/env')
    end

    it 'includes the run id' do
      output = Osemosys::Ec2UserData.new(run_id: 1337).to_base64_encoded

      decoded_output = Base64.decode64(output)

      expect(decoded_output).to include('1337')
    end
  end
end
