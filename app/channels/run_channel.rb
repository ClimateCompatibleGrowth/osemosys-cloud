class RunChannel < ApplicationCable::Channel
  def subscribed
    stream_from "run_#{params[:run_id]}"
  end
end
