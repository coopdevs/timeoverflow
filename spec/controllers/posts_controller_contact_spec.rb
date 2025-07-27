RSpec.describe OffersController, type: :controller do
  include ControllerMacros
  include ActiveJob::TestHelper

  let(:source_org) { Fabricate(:organization) }
  let(:dest_org)   { Fabricate(:organization) }

  let(:active_user) { Fabricate(:user) }
  let!(:source_member) { Fabricate(:member, user: active_user, organization: source_org, active: true) }

  let(:offer_owner) { Fabricate(:user) }
  let!(:dest_member) { Fabricate(:member, user: offer_owner, organization: dest_org, active: true) }

  let!(:offer) { Fabricate(:offer, user: offer_owner, organization: dest_org) }

  before do
    login(active_user)
    session[:current_organization_id] = source_org.id
    controller.instance_variable_set(:@current_organization, source_org)
    ActiveJob::Base.queue_adapter = :test
  end

  describe 'POST #contact' do
    it 'sends a contact‑request email and sets a flash notice' do
      perform_enqueued_jobs do
        expect {
          post :contact, params: { id: offer.id }
        }.to change { ActionMailer::Base.deliveries.size }.by(1)
      end

      expect(response).to redirect_to(offer)
      expect(flash[:notice]).to eq(I18n.t('posts.contact.success'))
    end

    context 'when the user belongs to the same organization as the post' do
      let!(:same_org_offer) { Fabricate(:offer, organization: source_org) }

      it 'does not send any email and shows an error flash' do
        expect {
          post :contact, params: { id: same_org_offer.id }
        }.not_to change { ActionMailer::Base.deliveries.size }

        expect(flash[:error]).to eq(I18n.t('posts.contact.error'))
      end
    end
  end
end
