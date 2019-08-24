class Run < ApplicationRecord
  include Statesman::Adapters::ActiveRecordQueries
  delegate :current_state, :history, :transition_to, :transition_to!,
    :can_transition_to?, :last_transition, to: :state_machine

  has_many :run_transitions, autosave: false

  belongs_to :user
  has_one_attached :model_file
  has_one_attached :data_file
  has_one_attached :result_file
  has_one_attached :log_file

  validates :name, presence: true
  validates :model_file, attached: true
  validates :data_file, attached: true

  def solving_time
    transitions = history

    return unless transitions.last&.final?

    transitions.last.created_at - transitions.first.created_at
  end

  def local_log_path
    "/tmp/run-#{id}.log"
  end

  def can_be_queued?
    can_transition_to? :queued
  end

  def state_machine
    @state_machine ||= StateMachine.new(
      self, transition_class: RunTransition
    )
  end

  def self.transition_class
    RunTransition
  end

  def humanized_status
    state.capitalize.to_s
  end

  private

  def self.initial_state
    :new
  end
  private_class_method :initial_state
end
