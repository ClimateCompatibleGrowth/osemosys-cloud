module ApplicationHelper
  def format_duration(duration)
    Time.at(duration).utc.strftime('%H:%M:%S')
  end

  def format_datetime(datetime)
    relative_time = distance_of_time_in_words_to_now(datetime) + ' ago'
    tooltip = datetime.strftime('%e %b %Y %H:%M:%S')
    render 'common/relative_time_with_tooltip', relative_time: relative_time, tooltip: tooltip
  end

  def download_button(attachment, tooltip: nil)
    tooltip ||= attachment.filename.to_s
    render 'common/download_button', attachment: attachment, tooltip: tooltip
  end
end
