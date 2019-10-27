class RunMailer < ApplicationMailer
  def run_finished_email
    @run = params[:run]
    mail(to: @run.user.email, subject: 'Run finished')
  end
end
