module ApplicationHelper
  def format_duration(duration)
    Time.at(duration).utc.strftime('%H:%M:%S')
  end

  def format_datetime(datetime)
    relative_time = distance_of_time_in_words_to_now(datetime) + ' ago'
    timestamp = datetime.strftime('%e %b %Y %H:%M:%S')
    "#{timestamp} (#{relative_time})"
  end

  def download_button(attachment, label: nil, tooltip: nil)
    tooltip ||= attachment.filename.to_s
    render 'common/download_button', attachment: attachment, tooltip: tooltip, label: label
  end
end
