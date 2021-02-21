class RunChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'runs'
  end
end
