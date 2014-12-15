require "spec_helper"

describe Inquiry, ".alphabetical_grouped_tags_desc" do
  let (:test_organization) { Fabricate(:organization) }
  let (:member) do
    Fabricate(:member,
              organization: test_organization,
              manager: false)
  end
  let! (:user) { member.user }
  let! (:inquiry_1) do
    Fabricate(:inquiry,
              user: member.user,
              organization: test_organization,
              tags: ["english", "bed", "pillow"])
  end
  let! (:inquiry_2) do
    Fabricate(:inquiry,
              user: member.user,
              organization: test_organization,
              tags: ["english", "extra", "cookie"])
  end
  let! (:inquiries_tags) do
    [["B", [["bed", 1]]], ["C", [["cookie", 1]]],
     ["E", [["english", 2], ["extra", 1]]], ["P", [["pillow", 1]]]]
  end

  it "returns list of alphabetical_grouped_tags_desc" do
    expect(Inquiry.active_alpha_tags(test_organization)).to eq inquiries_tags
  end
end
