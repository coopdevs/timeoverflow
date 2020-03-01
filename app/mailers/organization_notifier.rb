class OrganizationNotifier < ActionMailer::Base
  default from: "\"TimeOverflow\" <info@timeoverflow.org>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.organization_notifier.recent_posts.subject
  #
  def recent_posts(posts, locale, users)
    # last 10 posts of offers and inquiries
    @offers = posts.where(type: "Offer").take(10)
    @inquiries = posts.where(type: "Inquiry").take(10)

    @organization_name = posts.take.organization.name

    I18n.with_locale(locale) do
      mail(bcc: users.map(&:email))
    end
  end
end
