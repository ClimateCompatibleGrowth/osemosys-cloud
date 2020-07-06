# typed: strict
module Ec2
  class Instance < ApplicationRecord
    belongs_to :run

    validates :run, presence: true
  end
end
