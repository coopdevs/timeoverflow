require 'spec_helper'

describe HomeController, type: :controller do
  let(:user) { Fabricate(:user) }

  before { login(user) }

  describe '#index' do
    before { get :index }

    context 'When the user is not a member of any organization' do
      it 'redirects to the first organization\'s path' do
        expect(response).to redirect_to '/'
      end
    end

    context 'When the user is a member of two organizations' do
      let!(:member1) { Fabricate(:member, user: user) }
      let!(:member2) { Fabricate(:member, user: user) }

      it 'redirects to the first organization\'s path' do
        expect(response).to redirect_to organization_path(member1.organization_id)
      end
    end
  end
end
