require 'spec_helper'

describe MembersController do
  let(:organization) { Fabricate(:organization) }
  let!(:member_admin) do
    Fabricate(
      :member,
      organization: organization,
      manager: true
    )
  end
  let!(:member) do
    Fabricate(
      :member,
      organization: organization,
      manager: false
    )
  end
  let!(:another_member) do
    Fabricate(
      :member,
      organization: organization,
      manager: false
    )
  end
  let!(:inactive_member) do
    Fabricate(
      :member,
      organization: organization,
      manager: false,
      active: false
    )
  end
  let(:user) { member.user }
  let(:admin) { member_admin.user }

  describe '#index' do
    context 'when the user is not logged in' do
      it 'responds with a redirect' do
        get :index

        expect(response.status).to eq(302)
      end
    end

    context 'when the logged user is not an admin' do
      before { login(user) }

      it 'populates an array of active members' do
        get :index
        expect(assigns(:memberships)).to eq(
          [
            member_admin,
            member,
            another_member
          ]
        )
      end
    end

    context 'when the logged user is an admin' do
      before { login(admin) }

      it 'populates a collection of all members' do
        get :index
        expect(assigns(:memberships)).to eq(
          [
            member_admin,
            member,
            another_member,
            inactive_member
          ]
        )
      end
    end
  end
end
