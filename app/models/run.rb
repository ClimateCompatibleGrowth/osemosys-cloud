class Run < ApplicationRecord
  has_one_attached :model_file
  has_one_attached :data_file

  def solve_locally!
    Osemosys::SolveModel.new(s3_data_key: data_file.key, s3_model_key: model_file.key).call
  end
end
