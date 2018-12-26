class Run < ApplicationRecord
  has_one_attached :model_file
  has_one_attached :data_file
  has_one_attached :result_file
  has_one_attached :log_file

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

  def started?
    started_at.present?
  end

  def finished?
    finished_at.present?
  end

  def ongoing?
    started? && !finished?
  end

  # To move to presenter
  def can_be_started?
    !started?
  end

  def status
    return 'Finished' if finished?
    return 'Ongoing' if ongoing?
    return 'Started' if started?
    'Not started yet'
  end
end
