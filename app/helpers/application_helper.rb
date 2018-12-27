module ApplicationHelper
  def format_duration(duration)
    Time.at(duration).utc.strftime('%H:%M:%S')
  end

  def format_datetime(datetime)
    datetime.strftime('%e %b %Y %H:%M:%S')
  end
end
