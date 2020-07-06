# typed: false
class RunMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def run_finished_email
    @run = params[:run]
    mail(to: @run.user.email, subject: 'Run finished')
  end
end
