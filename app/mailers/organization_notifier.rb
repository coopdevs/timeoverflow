class OrganizationNotifier < ActionMailer::Base
  default from: "\"TimeOverflow\" <info@timeoverflow.org>"

  def recent_posts(posts, locale, users)
    @offers = posts.where(type: "Offer").take(10)
    @inquiries = posts.where(type: "Inquiry").take(10)

    @organization_name = posts.take.organization.name

    I18n.with_locale(locale) do
      mail(bcc: users.map(&:email))
    end
  end

  def new_petition(petition)
    @user = petition.user
    organization = petition.organization

    I18n.with_locale(locale) do
      mail(
        subject: "New Application - #{organization.name}",
        bcc: organization.all_managers.pluck(:email).uniq
      )
    end
  end

  def petition_sent(petition)
    @organization_name = petition.organization.name

    I18n.with_locale(locale) do
      mail(
        subject: 'Application sent correctly',
        to: petition.user.email
      )
    end
  end

  def member_deleted(member)
    @user = member.user
    organization = member.organization

    I18n.with_locale(locale) do
      mail(
        subject: "Membership deleted - #{organization.name}",
        bcc: organization.all_managers.pluck(:email).uniq
      )
    end
  end
end
