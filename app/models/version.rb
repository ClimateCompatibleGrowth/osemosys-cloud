class Version < ApplicationRecord
  belongs_to :user
  has_many :runs

  validates :name, presence: true
end
