class Run < ApplicationRecord
  has_one_attached :model_file
  has_one_attached :data_file
  has_one_attached :result_file

  def solve_locally!
    # Move to service object
    solved_file = Osemosys::SolveModel.new(s3_data_key: data_file.key, s3_model_key: model_file.key).call
    result_file.attach(io: solved_file, filename: File.basename(solved_file.to_path))
  end
end
