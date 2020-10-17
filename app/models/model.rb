class Model < ApplicationRecord
  belongs_to :user
  has_many :versions

  validates :name, presence: true
end
