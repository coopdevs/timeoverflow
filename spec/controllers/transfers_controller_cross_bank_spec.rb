RSpec.describe TransfersController, type: :controller do
  include ControllerMacros
  include ActiveJob::TestHelper

  let(:source_org) { Fabricate(:organization) }
  let(:dest_org)   { Fabricate(:organization) }

  let(:source_user) { Fabricate(:user) }
  let!(:source_member) { Fabricate(:member, user: source_user, organization: source_org) }

  let(:dest_user) { Fabricate(:user) }
  let!(:dest_member) { Fabricate(:member, user: dest_user, organization: dest_org) }

  let(:offer) { Fabricate(:offer, user: dest_user, organization: dest_org) }

  before do
    login(source_user)
    session[:current_organization_id] = source_org.id
    controller.instance_variable_set(:@current_organization, source_org)
  end

  describe 'POST #create (cross‑bank)' do
    let(:params) do
      {
        cross_bank: 'true',
        post_id: offer.id,
        transfer: { amount: 4, reason: 'Helping across banks' }
      }
    end

    subject(:request!) { post :create, params: params }

    it 'creates one transfer and six movements' do
      expect { request! }.to change(Transfer, :count).by(1)
        .and change(Movement, :count).by(6)
    end

    it 'redirects back to the post with a success notice' do
      request!
      expect(response).to redirect_to(offer)
      expect(flash[:notice]).to eq(I18n.t('transfers.cross_bank.success'))
    end
  end
end
