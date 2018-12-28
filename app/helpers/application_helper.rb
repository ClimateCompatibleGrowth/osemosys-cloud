module ApplicationHelper
  def format_duration(duration)
    Time.at(duration).utc.strftime('%H:%M:%S')
  end

  def format_datetime(datetime)
    datetime.strftime('%e %b %Y %H:%M:%S')
  end

  def download_button(attachment, tooltip: nil)
    tooltip ||= attachment.filename.to_s
    render 'common/download_button', attachment: attachment, tooltip: tooltip
  end
end
