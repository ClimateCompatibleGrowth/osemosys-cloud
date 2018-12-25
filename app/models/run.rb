class Run < ApplicationRecord
  has_one_attached :model_file
  has_one_attached :data_file
end
