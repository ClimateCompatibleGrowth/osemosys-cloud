class RunMailer < ApplicationMailer
  helper ApplicationHelper

  def run_finished_email
    @run = params[:run]
    mail(to: @run.user.email)
  end
end
