class MemberCompleteReportDecorator
  def initialize(org, collection)
    @org = org
    @collection = collection
  end

  def name(extension)
    "#{@org.name}_"\
    "#{User.model_name.human(count: :many)}_"\
    "#{Date.today}."\
    "#{extension}"
  end

  def headers
    [
      "N",
      User.human_attribute_name(:username),
      User.human_attribute_name(:email),
      User.human_attribute_name(:date_of_birth),
      User.human_attribute_name(:phone),
      User.human_attribute_name(:alt_phone),
      User.human_attribute_name(:address),
      User.human_attribute_name(:created_at),
      User.human_attribute_name(:updated_at),
      User.human_attribute_name(:gender),
      User.human_attribute_name(:description),
      User.human_attribute_name(:terms_accepted_at),
      User.human_attribute_name(:current_sign_in_at),
      User.human_attribute_name(:last_sign_in_at),
      User.human_attribute_name(:locale),
      User.human_attribute_name(:notifications)
    ]
  end

  def rows
    @collection.map do |member|
      [
        member.member_uid.to_s,
        member.user.username.to_s,
        member.user.email_if_real.to_s,
        nil_to_empty(member.user.date_of_birth),
        member.user.phone.to_s,
        member.user.alt_phone.to_s,
        member.user.address.to_s,
        member.user.created_at.to_formatted_s(:db),
        member.user.updated_at.to_formatted_s(:db),
        member.user.gender.to_s,
        member.user.description.to_s,
        member.user.terms_accepted_at.to_formatted_s(:db),
        nil_to_empty(member.user.current_sign_in_at),
        nil_to_empty(member.user.last_sign_in_at),
        member.user.locale.to_s,
        member.user.notifications.to_s
      ]
    end
  end

  def nil_to_empty(field)
    if field
      field.to_formatted_s(:db)
    else
      ''
    end
  end
end
