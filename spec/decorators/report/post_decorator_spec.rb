RSpec.describe Report::PostDecorator do
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
    offers = org.offers.of_active_members.active.group_by(&:category)

    Report::PostDecorator.new(org, offers, Offer)
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
                                      "",
                                      Offer.model_name.human,
                                      Post.human_attribute_name(:tag_list),
                                      User.model_name.human,
                                      Post.human_attribute_name(:created_at)
                                    ])
  end

  it "#rows" do
    # offer with member_uid
    offer = org.offers.of_active_members.active.first

    expect(decorator.rows).to eq([
                                   ["", category.name, "", "", ""],
                                   [offer.id, offer.title, offer.tag_list.to_s, "#{offer.user} (#{offer.member_uid})",
                                    offer.created_at.to_s]
                                 ])
  end
end
