require 'spec_helper'

describe Taggable do
  let (:tags) { %w(foo bar baz) }
  let (:more_tags) { %w(foo baz qux) }
  let (:organization) { Fabricate(:organization) }
  let! (:offer) { Fabricate(:offer,
                          organization: organization,
                          tags: tags) }
  let! (:another_offer) { Fabricate(:offer,
                          organization: organization,
                          tags: more_tags) }


  context "class methods and scopes" do
    it "tagged_with" do
      expect(Offer.tagged_with("bar")).to eq [offer]
    end

    it "all_tags" do
      expect(Offer.all_tags).to match_array(tags + more_tags)
    end

    it "find_like_tag" do
      expect(Offer.find_like_tag("foo")).to eq ["foo"]
      expect(Offer.find_like_tag("Foo")).to eq ["foo"]
      expect(Offer.find_like_tag("none")).to eq []
    end

    it "alphabetical_grouped_tags" do
      expect(Offer.alphabetical_grouped_tags).to eq({
        "B" => [["bar", 1], ["baz", 2]],
        "F" => [["foo", 2]],
        "Q" => [["qux", 1]]
      })
    end
  end
end
