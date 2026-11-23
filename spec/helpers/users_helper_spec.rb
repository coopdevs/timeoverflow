RSpec.describe UsersHelper do
  describe '#phone_to' do
    it 'links to a tel: URI without slashes' do
      expect(helper.phone_to('600112233')).to eq('<a href="tel:600112233">600112233</a>')
    end

    it 'removes whitespace from the URI but keeps it in the link text' do
      expect(helper.phone_to('+34 600 11 22 33'))
        .to eq('<a href="tel:+34600112233">+34 600 11 22 33</a>')
    end
  end
end
