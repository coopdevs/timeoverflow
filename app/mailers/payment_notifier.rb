class PaymentNotifier < ActionMailer::Base
  default from: "\"TimeOverflow\" <info@timeoverflow.org>"
  
  def transfer_source(user_name,time)
    # mail to user that transfer time
    horas = TimeFormatter.new.seconds_to_h_m(time).to_s
    mail(to: 'admin@timeoverflow.org', subject: 'Has pagado '+horas+" horas a "+user_name,body: 'SI')
  end
  
  def transfer_destination(user_name,time)
    # mail to user that transfer time
    horas = TimeFormatter.new.seconds_to_h_m(time).to_s
    mail(to: 'admin@timeoverflow.org', subject: 'Has recibido '+horas+" horas de "+user_name,body: 'SI')
  end
end
