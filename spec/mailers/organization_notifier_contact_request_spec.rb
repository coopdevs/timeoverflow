RSpec.describe OrganizationNotifier, type: :mailer do
  describe '.contact_request' do
    let(:source_org) { Fabricate(:organization) }
    let(:dest_org)   { Fabricate(:organization) }

    let(:requester) { Fabricate(:user, email: 'requester@example.com', locale: :en) }
    let!(:requester_member) { Fabricate(:member, user: requester, organization: source_org) }

    let(:offerer) { Fabricate(:user, email: 'offerer@example.com', locale: :en) }
    let!(:offerer_member) { Fabricate(:member, user: offerer, organization: dest_org) }

    let(:post_offer) { Fabricate(:offer, user: offerer, organization: dest_org, title: 'Gardening help') }

    subject(:mail) { described_class.contact_request(post_offer, requester, source_org) }

    it 'is sent to the offerer' do
      expect(mail.to).to eq([offerer.email])
    end

    it 'includes the post title in the localized subject' do
      expect(mail.subject).to include(post_offer.title)
    end

    it 'embeds the requester information in the body' do
      expect(mail.body.encoded).to include(requester.username)
      expect(mail.body.encoded).to include(source_org.name)
    end
  end
end
