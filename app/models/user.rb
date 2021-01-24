class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  enum locale: Language.to_enum_definition

  has_many :models
  has_many :runs
  has_many :versions
end
