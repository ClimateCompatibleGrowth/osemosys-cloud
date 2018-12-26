class Run < ApplicationRecord
  has_one_attached :model_file
  has_one_attached :data_file
  has_one_attached :result_file

  def solving_time
    return unless started_at && finished_at
    finished_at - started_at
  end

  def reset!
    self.finished_at = nil
    self.started_at = nil
    save
    result_file.purge
  end
end
