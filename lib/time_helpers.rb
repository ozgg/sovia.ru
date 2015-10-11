module TimeHelpers
  # Format time in W3C (e.g. for datetime attribute in time tag)
  def w3c
    strftime('%Y-%m-%dT%H:%M:%S%:z')
  end

  def iso_day
    strftime('%Y-%m-%d')
  end

  def microformat_minutes
    strftime('%Y-%m-%dT%H:%M')
  end
  
  def pubdate
    strftime('%d.%m.%Y, %H:%M')
  end
end
