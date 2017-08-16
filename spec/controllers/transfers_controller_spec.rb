require 'spec_helper'

describe TransfersController do
  let (:test_organization) { Fabricate(:organization) }
  let (:member_admin) { Fabricate(:member, organization: test_organization, manager: true) }
  let (:member_giver) { Fabricate(:member, organization: test_organization) }
  let (:member_taker) { Fabricate(:member, organization: test_organization) }

  include_context 'stub browser locale'

  before { set_browser_locale('ca') }

  describe '#new' do
    let(:user) { member_giver.user }

    before { login(user) }

    context 'when the destination is a user account' do
      let(:user_account) { user.members.find_by(organization: user.organizations.first).account }
      let(:params) do
        {
          id: user.id,
          destination_account_id: user_account.id
        }
      end

      it 'renders the :new template' do
        expect(get :new, params).to render_template(:new)
      end

      it 'finds the accountable' do
        get :new, params
        expect(assigns(:accountable)).to eq(member_giver)
      end

      it 'finds the destination account' do
        get :new, params
        expect(assigns(:destination_account)).to eq(user_account)
      end

      it 'finds the transfer source' do
        get :new, params
        expect(assigns(:source)).to eq(user_account.id)
      end

      it 'builds a transfer with the id of the destination' do
        get :new, params
        expect(assigns(:transfer).destination).to eq(user_account.id)
      end

      context 'when the offer is specified' do
        let(:offer) { Fabricate(:offer, organization: user.organizations.first) }

        it 'finds the transfer offer' do
          get :new, params.merge(offer: offer.id)
          expect(assigns(:offer)).to eq(offer)
        end

        it 'builds a transfer with the offer as post' do
          get :new, params.merge(offer: offer.id)
          expect(assigns(:transfer).post).to eq(offer)
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
      let(:params) do
        {
          id: test_organization.id,
          destination_account_id: test_organization.account.id
        }
      end

      it 'renders the :new template' do
        expect(get :new, params).to render_template(:new_organization)
      end

      it 'finds the accountable' do
        get :new, params
        expect(assigns(:accountable)).to eq(test_organization)
      end

      it 'finds the destination account' do
        get :new, params
        expect(assigns(:destination_account)).to eq(test_organization.account)
      end

      it 'builds a transfer with the id of the destination' do
        get :new, params
        expect(assigns(:transfer).destination).to eq(test_organization.account.id)
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

  describe 'POST #create' do
    before { login(user) }

    context 'with valid params' do
      context 'with an admin user logged' do
        subject(:post_create) do
          post 'create', transfer: {
            source: member_giver.account.id,
            destination: member_taker.account.id,
            amount: 5
          }
        end

        let(:user) { member_admin.user }

        it 'creates a new Transfer' do
          expect { post_create }.to change(Transfer, :count).by 1
        end

        it 'creates two Movements' do
          expect { post_create }.to change { Movement.count }.by 2
        end

        it 'updates the balance of both accounts' do
          expect do
            post_create
            member_giver.reload
          end.to change { member_giver.account.balance.to_i }.by -5

          expect do
            post_create
            member_taker.reload
          end.to change { member_taker.account.balance.to_i }.by 5
        end
      end

      context 'with a regular user logged' do
        subject(:post_create) do
          post 'create', transfer: {
            destination: member_taker.account.id,
            amount: 5
          }
        end

        let(:user) { member_giver.user }

        it 'creates a new Transfer' do
          expect { post_create }.to change(Transfer, :count).by 1
        end

        it 'creates two Movements' do
          expect { post_create }.to change { Movement.count }.by 2
        end

        it 'updates the balance of both accounts' do
          expect do
            post_create
            member_giver.reload
          end.to change { member_giver.account.balance.to_i }.by -5

          expect do
            post_create
            member_taker.reload
          end.to change { member_taker.account.balance.to_i }.by 5
        end

        it 'redirects to destination' do
          expect(post_create).to redirect_to(member_taker.user)
        end
      end
    end
  end
end
