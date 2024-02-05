RSpec.describe Report::MemberDecorator do
  let (:member) { Fabricate(:member) }
  let (:org) { member.organization }
  let (:decorator) do
    Report::MemberDecorator.new(org, org.members)
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
      User.human_attribute_name(:alt_phone),
      User.human_attribute_name(:created_at),
      User.human_attribute_name(:last_sign_in_at),
      User.human_attribute_name(:locale),
      Account.human_attribute_name(:balance)
    ])
  end

  it "#rows" do
    expect(decorator.rows).to eq([
      [
        member.member_uid,
        member.user.username,
        member.user.email_if_real,
        member.user.phone,
        member.user.alt_phone,
        member.user.created_at.to_s,
        member.user.last_sign_in_at.to_s,
        member.user.locale,
        member.account_balance.to_s
      ]
    ])
  end
end
