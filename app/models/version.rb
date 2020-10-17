class Version < ApplicationRecord
  belongs_to :model
  belongs_to :user
  has_many :runs

  validates :name, presence: true
end
