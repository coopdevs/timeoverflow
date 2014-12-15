require "spec_helper"

describe Offer, ".alphabetical_grouped_tags_desc" do
  let (:test_organization) { Fabricate(:organization) }
  let (:member) do
    Fabricate(:member,
              organization: test_organization,
              manager: false)
  end
  let! (:user) { member.user }
  let! (:offer_1) do
    Fabricate(:offer,
              user: member.user,
              organization: test_organization,
              tags: ["tree", "car", "window"])
  end
  let! (:offer_2) do
    Fabricate(:offer,
              user: member.user,
              organization: test_organization,
              tags: ["english", "wallet", "window"])
  end
  let! (:offers_tags) do
    [["C", [["car", 1]]], ["E", [["english", 1]]],
     ["T", [["tree", 1]]], ["W", [["window", 2], ["wallet", 1]]]]
  end

  it "returns list of alphabetical_grouped_tags_desc" do
    expect(Offer.active_alpha_tags(test_organization)).to eq offers_tags
  end
end
