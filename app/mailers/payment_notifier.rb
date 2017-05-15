class PaymentNotifier < ActionMailer::Base
  default from: "\"TimeOverflow\" <info@timeoverflow.org>"
  
  # @param username [String] username of the destination account
  # @param time [String]
  def transfer_source(user, username_destination, time)
    mail(to: "#{user.email}", subject: default_i18n_subject(time: time, username_destination: username_destination), body: 'SI')
  end
  
  # @param username [String] username of the source account
  # @param time [String]
  def transfer_destination(user, username_source, time)
    # Todo: Send with destination locale
    mail(to: "#{user.email}", subject: default_i18n_subject(time: time, username_source: username_source), body: 'SI')
  end
end