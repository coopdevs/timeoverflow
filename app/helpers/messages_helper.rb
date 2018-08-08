module MessagesHelper
  def alert_class(alert)
    if alert == 'error' || alert == 'alert'
      'alert-danger'
    elsif alert == 'success'
      'alert-success'
    elsif alert == 'notice'
      'alert-info'
    else
      'alert-info'
    end
  end
end
