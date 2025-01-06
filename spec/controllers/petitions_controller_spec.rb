RSpec.describe PetitionsController do
  let!(:organization) { Fabricate(:organization) }
  let(:user) { Fabricate(:user) }
  let!(:admin) { Fabricate(:member, organization: organization, manager: true) }

  describe 'POST #create' do
    before { login(user) }

    it 'creates the petition' do
      request.env['HTTP_REFERER'] = organizations_path

      expect do
        post :create, params: { user_id: user.id, organization_id: organization.id }
      end.to change(Petition, :count).by(1)
      expect(response).to redirect_to(organizations_path)
    end
  end

  describe 'PUT #update' do
    before { login(admin.user) }
    let(:petition) { Petition.create(user: user, organization: organization) }

    it 'decline the petition' do
      put :update, params: { status: 'declined', id: petition.id }

      petition.reload
      expect(petition.status).to eq('declined')
    end

    it 'accept the petition and add the user to the org' do
      put :update, params: { status: 'accepted', id: petition.id }

      petition.reload
      expect(user.members.last.organization.id).to eq(organization.id)
      expect(petition.status).to eq('accepted')
    end
  end

  describe 'GET #manage' do
    before do
      allow(controller).to receive(:current_organization) { organization }
      login(admin.user)
    end
    let!(:petition) { Petition.create(user: user, organization: organization) }

    it 'populates a list of users with pending petitions' do
      get :manage

      expect(assigns(:users)).to include(user)
    end
  end
end
