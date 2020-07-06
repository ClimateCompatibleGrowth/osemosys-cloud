# typed: false
module ApplicationHelper
  def format_duration(duration)
    (duration / 3600).to_i.to_s.rjust(2, '0') + ':' + Time.at(duration).utc.strftime('%M:%S')
  end

  def format_datetime(datetime)
    return unless datetime

    relative_time = distance_of_time_in_words_to_now(datetime) + ' ago'
    timestamp = datetime.strftime('%e %b %Y %H:%M:%S')
    "#{relative_time} <br/> (#{timestamp})".html_safe
  end

  def download_button(attachment, label: nil, tooltip: nil, style: 'link')
    tooltip ||= attachment.filename.to_s
    render(
      'common/download_button',
      attachment: attachment,
      tooltip: tooltip,
      label: label,
      style: style,
    )
  end
end
