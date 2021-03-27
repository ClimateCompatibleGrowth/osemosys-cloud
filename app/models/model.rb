class Model < ApplicationRecord
  include Discard::Model

  belongs_to :user
  has_many :versions

  validates :name, presence: true
end
