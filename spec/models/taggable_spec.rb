RSpec.describe Taggable do
  let(:organization) { Fabricate(:organization) }
  let(:tags) { %w(foo bar baz test) }
  let(:more_tags) { %w(foo baz qux têst) }
  let!(:offer) do
    Fabricate(
      :offer,
      organization: organization,
      tags: tags
    )
  end
  let!(:another_offer) do
    Fabricate(
      :offer,
      organization: organization,
      tags: more_tags
    )
  end

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
      expect(Offer.find_like_tag("test")).to match_array %w[test têst]
      expect(Offer.find_like_tag("têst")).to match_array %w[test têst]
    end

    describe ".alphabetical_grouped_tags" do
      let(:tags) { %w(foo bar baz Boo) }
      let(:more_tags) { %w(foo baz qux) }

      it "sorts them by alphabetical order case insensitive" do
        expect(Offer.alphabetical_grouped_tags).to eq({
                                                        "B" => [["bar", 1], ["baz", 2], ["Boo", 1]],
                                                        "F" => [["foo", 2]],
                                                        "Q" => [["qux", 1]]
                                                      })
      end
    end
  end

  it "#tag_list= writter accepts string and array" do
    offer = Offer.new

    offer.tag_list = %w[a b]
    expect(offer.tag_list).to eq "a, b"

    offer.tag_list = "c, d"
    expect(offer.tag_list).to eq "c, d"
  end
end
