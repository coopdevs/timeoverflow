RSpec.describe Report::DetailedDecorator do
  let (:member) { Fabricate(:member) }
  let (:org) { member.organization }
  let (:decorator) do
    Report::DetailedDecorator.new(org)
  end
  let (:category) { Fabricate(:category) }
  let (:transfer) { Fabricate(:transfer, source: org.account, destination: member.account) }
  let! (:offer) do
    Fabricate(:offer,
              user: member.user,
              organization: org,
              category: category)
  end

  it "#name" do
    expect(decorator.name(:csv)).to eq(
      "#{org.name.parameterize}_"\
      "#{I18n.t('global.detailed')}_"\
      "#{Date.today}."\
      "csv"
    )
  end

  it "#headers" do
    expect(decorator.headers).to eq(["#{org.name} #{I18n.t('global.detailed')}"])
  end

  it "#rows" do
    expect(decorator.rows.to_s).to include(org.name)
    expect(decorator.rows.to_s).to include(transfer.reason.to_s)
    expect(decorator.rows.to_s).to include(offer.title)
    expect(decorator.rows.to_s).to include(member.user.username)
    expect(decorator.rows.to_s).to include(category.to_s)
  end
end
