class TimeFormatter
  def mdash
    raw "&mdash;"
  end

  def seconds_to_h_m(seconds)
    sign = seconds <=> 0
    if sign.try :nonzero?
      minutes, _seconds = seconds.abs.divmod(60)
      hours, minutes = minutes.divmod(60)
      raw format("%s%d:%02d", ("-" if sign < 0), hours, minutes)
    else
      mdash
    end
  end
end
