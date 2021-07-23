require 'rails_helper'

RSpec.describe Ec2::UserData do
  describe '#to_base64_encoded' do
    it 'is a base64 encoded text' do
      output = Ec2::UserData.new(run_id: 1).to_base64_encoded

      decoded_output = Base64.decode64(output)

      expect(decoded_output).to include('#!/bin/bash')
    end

    it 'includes the run id' do
      output = Ec2::UserData.new(run_id: 1337).to_base64_encoded

      decoded_output = Base64.decode64(output)

      expect(decoded_output).to include('1337')
    end
  end
end
