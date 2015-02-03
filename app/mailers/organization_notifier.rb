class OrganizationNotifier < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.organization_notifier.recent_posts.subject
  #
  def recent_posts(posts)
    # last 10 posts of offers and inquiries
    @offers = posts.where(type: "Offer").take(10)
    @inquiries = posts.where(type: "Inquiry").take(10)
    # users with email ok
    emails = posts.take.organization.users.where("sign_in_count > 0").pluck(:email)

    mail(bcc: emails)
  end
end
