class MemberReportDecorator
  def initialize(collection)
    @collection = collection
  end

  def headers
    [
      "N",
      User.human_attribute_name(:username),
      User.human_attribute_name(:email),
      User.human_attribute_name(:phone),
      User.human_attribute_name(:alt_phone)
    ]
  end

  def rows
    @collection.map do |member|
      [
        member.member_uid,
        member.user.username,
        member.user.email,
        member.user.phone,
        member.user.alt_phone
      ]
    end
  end
end
