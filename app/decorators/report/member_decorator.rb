class Report::MemberDecorator
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
      User.human_attribute_name(:phone),
      User.human_attribute_name(:alt_phone),
      User.human_attribute_name(:created_at),
      User.human_attribute_name(:last_sign_in_at)
    ]
  end

  def rows
    @collection.map do |member|
      [
        member.member_uid,
        member.user.username,
        member.user.email_if_real,
        member.user.phone,
        member.user.alt_phone,
        member.user.created_at.to_s,
        member.user.last_sign_in_at.to_s
      ]
    end
  end
end
