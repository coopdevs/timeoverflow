class OrganizationNotifier < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.organization_notifier.recent_posts.subject
  #
  def recent_posts
    mail to: "to@example.org"
  end
end
