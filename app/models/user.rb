class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  enum locale: Language.to_enum_definition

  validates :name, :country_code, :locale, presence: true

  has_many :models
  has_many :runs
  has_many :versions
end
