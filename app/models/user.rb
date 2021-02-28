class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  enum locale: Language.to_enum_definition

  validates :name, :country_code, :locale, presence: true

  has_many :models
  has_many :runs
  has_many :versions

  def country_name
    return '-' if country_code.blank?

    ISO3166::Country[country_code].translations[I18n.locale.to_s]
  end
end
