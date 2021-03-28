require 'csv'

class UsersToCsv
  HEADERS = [
    User.human_attribute_name(:id),
    User.human_attribute_name(:name),
    User.human_attribute_name(:email),
    User.human_attribute_name(:country_code),
    User.human_attribute_name(:created_at),
    Run.model_name.human.pluralize,
    I18n.t('admin.users.index.last_run_at'),
    I18n.t('admin.users.index.server_time'),
  ].freeze

  def initialize(users)
    @users = users
  end

  def generate
    CSV.generate do |csv_file|
      csv_file << HEADERS

      users.each do |user|
        csv_file << user_to_csv(user)
      end
    end
  end

  private

  attr_reader :users

  def user_to_csv(user)
    [
      user.id,
      user.name,
      user.email,
      user.country_name,
      user.created_at.strftime('%e %b %Y'),
      user.runs.length,
      user.runs.kept.first&.created_at&.strftime('%e %b %Y') || '-',
      ApplicationController.helpers.format_duration(user.runs.map(&:finished_in).compact.sum) || '-',
    ]
  end
end
