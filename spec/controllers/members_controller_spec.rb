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

  describe 'GET #show' do
    context 'when the user is not logged in' do
      it 'responds with a redirect' do
        get :show, member_uid: member.member_uid

        expect(response.status).to eq(302)
      end
    end

    context 'when the user is logged in' do
      context 'as an admin' do
        before { login(admin) }

        it 'renders a page with a link to edit user\'s details' do
          get :show, member_uid: member.member_uid

          expect(response.body).to include("<a href=\"/users/#{member.user_id}/edit\">")
        end

        it 'renders a page with a link to give time to the member' do
          get :show, member_uid: member.member_uid

          expect(response.body).to include("<a href=\"/members/#{member.member_uid}/give_time\">")
        end
      end

      context 'as a member' do
        before { login(user) }

        context 'and the member is associated to the current user' do
          it 'renders a page with a link to edit user\'s details' do
            get :show, member_uid: member.member_uid

            expect(response.body).to include("<a href=\"/users/#{member.user_id}/edit\">")
          end

          it 'renders a page without a link to give time to the member' do
            get :show, member_uid: member.member_uid

            expect(response.body).to_not include("<a href=\"/members/#{member.member_uid}/give_time\">")
          end
        end

        context 'and the member is not associated to the current user' do
          it 'renders a page without a link to edit user\'s details' do
            get :show, member_uid: member_admin.member_uid

            expect(response.body).to_not include("<a href=\"/users/#{member_admin.user_id}/edit\">")
          end

          it 'renders a page with a link to give time to the member' do
            get :show, member_uid: member_admin.member_uid

            expect(response.body).to include("<a href=\"/members/#{member_admin.member_uid}/give_time\">")
          end
        end
      end
    end
  end
end
