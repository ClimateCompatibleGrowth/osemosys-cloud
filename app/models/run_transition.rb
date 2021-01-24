class RunTransition < ApplicationRecord
  validates :to_state, inclusion: { in: Run::StateMachine.states }

  belongs_to :run, inverse_of: :run_transitions

  def humanized_to_state
    I18n.t("run_state.#{to_state}")
  end

  def final?
    to_state == 'succeeded' || to_state == 'failed'
  end

  def duration
    metadata['duration']
  end
end
