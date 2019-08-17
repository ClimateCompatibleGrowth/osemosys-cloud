class Run < ApplicationRecord
  belongs_to :user
  has_one_attached :model_file
  has_one_attached :data_file
  has_one_attached :result_file
  has_one_attached :log_file

  enum outcome: { success: 'success', failure: 'failure' }

  def solving_time
    return unless started_at && finished_at
    finished_at - started_at
  end

  def reset!
    self.finished_at = nil
    self.started_at = nil
    self.queued_at = nil
    save
    result_file.purge
    log_file.purge
  end

  def local_log_path
    "/tmp/run-#{id}.log"
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

  def in_queue?
    return false if started? || finished?
    queued_at.present?
  end

  # To move to presenter
  def can_be_queued?
    return false if started? || finished?
    !in_queue?
  end

  def status
    return 'Finished' if finished?
    return 'Ongoing' if ongoing?
    return 'Started' if started?
    return 'In queue' if in_queue?
    'Not started yet'
  end
end
