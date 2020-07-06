class RunResult < ApplicationRecord
  belongs_to :run

  has_one_attached :result_file
  has_one_attached :csv_results
end
