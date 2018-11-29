module DateHelper
  def duration_ago_string(datetime)
    seconds_ago = (Time.now - datetime).to_i

    string = (if seconds_ago < 60
      "#{seconds_ago} seconds"
    elsif seconds_ago < 3600
      "#{seconds_ago / 60} minutes"
    elsif seconds_ago < 86400
      "#{seconds_ago / 3600} hours"
    else
      "#{seconds_ago / 86400} days"
    end)

    "#{string} ago"
  end

  def duration_ago_span(datetime)
    capture_haml do
      haml_tag :span do
        haml_concat duration_ago_string(datetime)
      end
    end
  end
end
