require "spec_helper"

describe PostReportDecorator do
  let (:org) { Fabricate(:organization) }
  let (:member) { Fabricate(:member, organization: org) }
  let (:category) { Fabricate(:category) }
  let! (:offer) do
    Fabricate(:offer,
              user: member.user,
              organization: org,
              category: category)
  end

  let (:decorator) do
    offers = org.offers.group_by(&:category)

    PostReportDecorator.new(org, offers, Offer)
  end

  it "#name" do
    expect(decorator.name(:csv)).to eq(
      "#{org.name}_"\
      "#{Offer.model_name.human(count: :many)}_"\
      "#{Date.today}.csv"
    )
  end

  it "#headers" do
    expect(decorator.headers).to eq([
      Offer.model_name.human,
      User.model_name.human
    ])
  end

  it "#rows" do
    expect(decorator.rows).to eq([
      [category.name, ""],
      [offer.title, "#{offer.user} (#{offer.member_id})"]
    ])
  end
end
