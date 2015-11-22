require "spec_helper"

describe MemberReportDecorator do
  let (:member) { Fabricate(:member) }
  let (:org) { member.organization }
  let (:decorator) do
    MemberReportDecorator.new(org, org.members)
  end

  it "#name" do
    expect(decorator.name(:csv)).to eq(
      "#{org.name}_"\
      "#{User.model_name.human(count: :many)}_"\
      "#{Date.today}.csv"
    )
  end

  it "#headers" do
    expect(decorator.headers).to eq([
      "N",
      User.human_attribute_name(:username),
      User.human_attribute_name(:email),
      User.human_attribute_name(:phone),
      User.human_attribute_name(:alt_phone)
    ])
  end

  it "#rows" do
    expect(decorator.rows).to eq([
      [
        member.member_uid,
        member.user.username,
        member.user.email_if_real,
        member.user.phone,
        member.user.alt_phone
      ]
    ])
  end
end
