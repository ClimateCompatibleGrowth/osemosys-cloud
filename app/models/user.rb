class User < ApplicationRecord
  acts_as_taggable_on :tags
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  enum locale: Language.to_enum_definition

  validates :name, :country_code, :locale, presence: true

  has_many :models
  has_many :runs, -> { ordered }
  has_many :versions

  def country_name
    return '-' if country_code.blank?

    ISO3166::Country[country_code].translations[I18n.locale.to_s]
  end

  def complete_profile_information?
    name.present? && country_code.present?
  end

  def inactive?
    !active?
  end
end
