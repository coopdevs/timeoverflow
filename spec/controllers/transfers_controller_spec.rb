require 'spec_helper'

describe TransfersController do
  let (:test_organization) { Fabricate(:organization)}
  let (:member_admin) { Fabricate(:member, organization: test_organization, manager: true)}
  let (:member_giver) { Fabricate(:member, organization: test_organization) }
  let (:member_taker) { Fabricate(:member, organization: test_organization) }

  include_context "stub browser locale"

  before { set_browser_locale('ca') }

  describe '#new' do
    let(:user) { member_giver.user }

    before { login(user) }

    context 'when the destination is a user account' do
      let(:params) { { id: user.id } }

      it 'renders the :new template' do
        expect(get :new, params).to render_template(:new)
      end

      it 'finds the user' do
        get :new, params
        expect(assigns(:user)).to eq(user)
      end

      it 'finds the destination account' do
        get :new, params
        user_account = user.members.find_by(organization: user.organizations.first).account

        expect(assigns(:destination)).to eq(user_account.id)
      end

      it 'finds the transfer source' do
        get :new, params
        source = user.members.find_by(organization: user.organizations.first).account.id

        expect(assigns(:source)).to eq(source)
      end

      context 'when the offer is specified' do
        let(:offer) { Fabricate(:offer, organization: user.organizations.first) }

        it 'finds the transfer offer' do
          get :new, params.merge(offer: offer.id)
          expect(assigns(:offer)).to eq(offer)
        end
      end

      context 'when the offer is not specified' do
        it 'does not find any offer' do
          get :new, params
          expect(assigns(:offer)).to be_nil
        end
      end

      context 'when the user is admin of the current organization' do
        let(:user) { member_admin.user }

        it 'finds all accounts in the organization as sources' do
          get :new, params
          expect(assigns(:sources)).to contain_exactly(
            test_organization.account, member_admin.account
          )
        end
      end

      context 'when the user is not admin of the current organization' do
        it 'does not assign :sources' do
          get :new, params
          expect(assigns(:sources)).to be_nil
        end
      end
    end

    context 'when the destination is an organization account' do
      let(:params) { { id: test_organization.id, organization: true } }

      it 'renders the :new template' do
        expect(get :new, params).to render_template(:new_organization)
      end

      it 'finds the destination account' do
        get :new, params
        expect(assigns(:destination)).to eq(test_organization.account.id)
      end

      context 'when the user is the admin of the current organization' do
        let(:user) { member_admin.user }

        it 'renders the page successfully' do
          expect(get :new, params).to be_ok
        end
      end

      it 'finds the transfer source' do
        get :new, params
        giver_account = user.members.find_by(organization: test_organization).account.id

        expect(assigns(:source)).to eq(giver_account)
      end

      context 'when an offer is specified' do
        let(:offer) { Fabricate(:offer, organization: test_organization) }

        it 'finds the transfer offer' do
          get :new, params.merge(offer: offer.id)
          expect(assigns(:offer)).to eq(offer)
        end
      end
    end
  end

  describe "POST #create" do
    before { login(user) }

    context "with valid params" do
      context "with an admin user logged" do

        let(:user) { member_admin.user }
        subject { post 'create', transfer: {source: member_giver.account.id, destination: member_taker.account.id, amount: 5} }

        it "creates a new Transfer" do
          expect {
            subject
          }.to change(Transfer, :count).by 1
        end

        it "creates two Movements" do
          expect {
            subject
          }.to change { Movement.count}.by 2
        end

        it "updates the balance of both accounts" do
          expect {
            subject
            member_giver.reload
          }.to change { member_giver.account.balance.to_i }.by -5

          expect {
            subject
            member_taker.reload
          }.to change { member_taker.account.balance.to_i }.by 5
        end
      end

      context "with a regular user logged" do

        let(:user) { member_giver.user }
        subject { post 'create', transfer: {destination: member_taker.account.id, amount: 5} }

        it "creates a new Transfer" do
          expect {
            subject
          }.to change(Transfer, :count).by 1
        end

        it "creates two Movements" do
          expect {
            subject
          }.to change { Movement.count}.by 2
        end

        it "updates the balance of both accounts" do
          expect {
            subject
            member_giver.reload
          }.to change { member_giver.account.balance.to_i }.by -5

          expect {
            subject
            member_taker.reload
          }.to change { member_taker.account.balance.to_i }.by 5
        end

        it "redirects to destination" do
          expect(subject).to redirect_to(member_taker.user)
        end
      end
    end

  end
end
