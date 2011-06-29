module ApplicationHelper
  # convert "09:30" to 9.5 or "9:45" to 9.75 etc
  def hours_to_numeric(hours)
    Time::hours_to_numeric(hours)
  end

  # convert 9.5 to 9:30 or 8.75 to 8:45 etc
  def numeric_to_hours(hours)
    Time::numeric_to_hours(hours)
  end

  # get current time with columns
  def get_time_as_string
    Time::hours_to_numeric("#{Time.new.hour}:#{Time.new.min}")
  end

  # making notice and alert messages to be like in jQuery UI
  def notice_alert
    out = ""
    
    unless alert.nil?
      out += %Q(<div class="ui-widget">
				<div class="ui-state-error ui-corner-all">
					<p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
					#{alert}</p>
				</div>
			</div><br />)
    end

    unless notice.nil?
      out += %Q(<div class="ui-widget">
				<div class="ui-state-highlight ui-corner-all">
					<p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-info"></span>
					#{notice}.</p>
				</div>
			</div><br />)
    end
    out.html_safe
  end

  # changes new line to br
  def nl2br(s)
     raw s.to_s.gsub(/\n/, '<br />')
  end
  
end
