class RunResult < ApplicationRecord
  belongs_to :run

  has_one_attached :result_file
  has_one_attached :csv_results

  def visualization_url
    return unless csv_results_url

    "https://osemosys-cloud-visualization.herokuapp.com/?url=#{CGI.escape(csv_results_url)}"
  end

  private

  def csv_results_url
    return unless csv_results.attached?

    Rails.application.routes.url_helpers.rails_blob_url(
      csv_results,
      host: 'osemosys-cloud.herokuapp.com',
    )
  end
end
