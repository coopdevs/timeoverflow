RSpec.describe OrganizationsController do
  let!(:organization) { Fabricate(:organization) }
  let(:member) { Fabricate(:member, organization: organization) }
  let(:user) { member.user }

  describe 'GET #index' do
    it 'populates and array of organizations' do
      get :index

      expect(assigns(:organizations)).to eq([organization])
    end
  end

  describe 'GET #show' do
    it 'displays the organization page' do
      get 'show', params: { id: organization.id }

      expect(assigns(:organization)).to eq(organization)
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #select_organization' do
    it 'it shows the organizations in which the user is a member' do
      login(member.user)

      get :select_organization

      expect(assigns(:organizations)).to eq([organization])
      expect(response.status).to eq(200)
    end
  end

  describe 'POST #update' do
    context 'with a logged user (admins organization)' do
      let(:member) { Fabricate(:member, organization: organization, manager: true) }

      it 'allows to update organization' do
        login(member.user)

        post :update, params: { id: organization.id, organization: { name: 'New org name' } }

        organization.reload
        expect(organization.name).to eq('New org name')
      end
    end

    context 'without a logged user' do
      it 'does not allow to update organization' do
        post :update, params: { id: organization.id, organization: { name: 'New org name' } }

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq('You are not authorized to perform this action.')
      end
    end
  end

  describe '#set_current' do
    before { login(user) }

    it 'stores the given organization as current organization in session' do
      post 'set_current', params: { id: organization.id }

      expect(session[:current_organization_id]).to eq(organization.id)
    end
  end
end
