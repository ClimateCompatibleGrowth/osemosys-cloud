class RunResult < ApplicationRecord
  belongs_to :run

  has_one_attached :result_file
  has_one_attached :csv_results

  def visualization_url
    return unless result_file_url

    "http://visualization.osemosys-cloud.com/?model=#{CGI.escape(result_file_url)}&locale=#{run.language}" # # rubocop:disable Layout/LineLength
  end

  def result_file_url
    return unless result_file.attached?

    Rails.application.routes.url_helpers.rails_blob_url(
      result_file,
      host: 'www.osemosys-cloud.com',
    )
  end
end
