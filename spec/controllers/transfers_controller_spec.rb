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
    let(:params) { { id: user.id } }

    before { login(user) }

    it 'renders the :new template' do
      expect(get :new, params).to render_template(:new)
    end

    it 'finds the user' do
      get :new, params
      expect(assigns(:user)).to eq(user)
    end

    it 'finds the destination account' do
      get :new, params
      account = user.members.find_by(organization: user.organizations.first).account

      expect(assigns(:destination)).to eq(account.id)
    end

    it 'finds the transfer source' do
      get :new, params
      source = user.members.find_by(organization: user.organizations.first).account.id

      expect(assigns(:source)).to eq(source)
    end

    context 'when the offer is specified' do
      let(:offer) { Fabricate(:offer, organization: user.organizations.first) }

      before { params.merge!(offer: offer.id) }

      it 'finds the transfer offer' do
        get :new, params
        offer = user.organizations.first.offers.find(params[:offer])

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
