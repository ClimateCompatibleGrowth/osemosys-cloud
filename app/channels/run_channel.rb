class RunChannel < ApplicationCable::Channel
  # Called when the consumer has successfully
  # become a subscriber to this channel.
  def subscribed
    stream_from 'ping' # This should be run id?
    require 'pry'; binding.pry
  end
end
