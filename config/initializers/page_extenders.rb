class Time
  # converts float to human time
  # i.e. 9.5 to 9:30 or 8.75 to 8:45 etc
  def self.numeric_to_hours(hours)
    return "0:00" if hours.nil? || hours == 0
    hrs_i = hours.to_i
    hrs_f = hours.to_f
    if hrs_i != 0
      units = hrs_f % hrs_i
    else
      units = hrs_f
    end
    units = ((units / 5) * 300)
    hrs_s = "#{hours.to_i.to_s}:#{units.to_i.to_s.rjust(2, "0")}"
    hrs_s += "0" if hrs_s =~ /:0$/
    return hrs_s
  end
  
  
  # converst human time to float
  # i.e. "09:30" to 9.5 or "9:45" to 9.75 etc
  def self.hours_to_numeric(hours)
    return 0 if hours.blank?
    
    if hours.to_s.include? ":"
      left = hours[0,hours.index(":")].to_i
      right = hours[hours.index(":")+1,2].to_i
      return left + (((right * 5) / 3) / 100.to_f)
    else
      return hours.to_s.gsub(",",".").to_f
    end
  end
  
  
  # it is needed to have date in correct format for js
  # it is here to keep in one place
  def self.get_js_date
    Time.now.strftime(Date::DATE_FORMATS[:default])
  end
  
  # get current time with columns
  def self.get_time_with_columns
    hours_to_numeric("#{Time.new.hour}:#{Time.new.min}")
  end
end