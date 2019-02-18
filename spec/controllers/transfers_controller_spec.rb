require 'spec_helper'

RSpec.describe TransfersController do
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
      let(:user_account) do
        user.members.find_by(organization: user.organizations.first).account
      end
      let(:params) do
        {
          id: user.id,
          destination_account_id: user_account.id
        }
      end

      it 'finds the accountable' do
        get :new, params
        expect(response.body)
          .to include("<a href=\"/members/#{member_giver.user.id}\">#{member_giver.display_name_with_uid}</a>")
      end

      it 'finds the destination account' do
        get :new, params
        expect(response.body).to include("<input class=\"hidden form-control form-control\" type=\"hidden\" value=\"#{user_account.id}\" name=\"transfer[destination]\" id=\"transfer_destination\" />")
      end

      it 'builds a transfer with the id of the destination' do
        get :new, params
        expect(response.body)
          .to include("<input class=\"hidden form-control form-control\" type=\"hidden\" value=\"#{user_account.id}\" name=\"transfer[destination]\" id=\"transfer_destination\" />")
      end

      context 'when the offer is specified' do
        let(:offer) { Fabricate(:offer, organization: user.organizations.first) }

        it 'finds the transfer offer' do
          get :new, params.merge(offer: offer.id)
          expect(response.body).to include("<h3>#{offer}</h3>")
        end

        it 'builds a transfer with the offer as post' do
          get :new, params.merge(offer: offer.id)
          expect(response.body).to include("<input class=\"hidden form-control form-control\" type=\"hidden\" value=\"#{offer.id}\" name=\"transfer[post_id]\" id=\"transfer_post_id\" />")
        end
      end

      context 'when the offer is not specified' do
        it 'does not find any offer' do
          get :new, params
          expect(response.body).to include('<option value="">')
        end
      end

      context 'when the user is admin of the current organization' do
        let(:user) { member_admin.user }

        it 'finds all accounts in the organization as sources' do
          get :new, params

          expect(response.body).to include("<select id=\"select2-time\" class=\"form-control\" name=\"transfer[source]\"><option selected=\"selected\" value=\"#{member_admin.account.id}\">#{member_admin.member_uid} Member #{member_admin}</option>")
          expect(response.body).to include("<option value=\"#{test_organization.account.id}\"> Organization #{test_organization}</option></select>")
        end
      end

      context 'when the user is not admin of the current organization' do
        it 'does not assign :sources' do
          get :new, params
          expect(response.body)
            .not_to include("<select id=\"select2-time\" class=\"form-control\" name=\"transfer[source]\">")
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

      it 'finds the accountable' do
        get :new, params
        expect(response.body)
          .to include("<a href=\"/organizations/#{test_organization.id}\">#{test_organization}</a>")
      end

      it 'finds the destination account' do
        get :new, params
        expect(response.body).to include("<input class=\"hidden form-control form-control\" type=\"hidden\" value=\"#{test_organization.account.id}\" name=\"transfer[destination]\" id=\"transfer_destination\" />")
      end

      it 'builds a transfer with the id of the destination' do
        get :new, params
        expect(response.body)
          .to include("<input class=\"hidden form-control form-control\" type=\"hidden\" value=\"#{test_organization.account.id}\" name=\"transfer[destination]\" id=\"transfer_destination\" />")
      end

      context 'when the user is the admin of the current organization' do
        let(:user) { member_admin.user }

        it 'renders the page successfully' do
          expect(get :new, params).to be_ok
        end

        it 'finds the transfer source' do
          get :new, params

          expect(response.body).to include("<select id=\"select2-time\" class=\"form-control\" name=\"transfer[source]\"><option selected=\"selected\" value=\"#{member_admin.account.id}\">#{member_admin.member_uid} Member #{member_admin}</option>")
          expect(response.body).to include("<option value=\"#{test_organization.account.id}\">#{test_organization.id} Organization #{test_organization}</option></select>")
          HTML
        end
      end

      context 'when an offer is specified' do
        let(:offer) { Fabricate(:offer, organization: test_organization) }

        it 'finds the transfer offer' do
          get :new, params.merge(offer: offer.id)
          expect(response.body).to include("<h3>#{offer}</h3>")
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

    context 'with invalid params' do
      let(:user) { member_giver.user }
      let(:referer) { "/transfers/new?destination_account_id=#{member_taker.account.id}" }

      before do
        request.env["HTTP_REFERER"] = referer
      end

      it 'does not create any Transfer and redirects to :back if the amount is 0' do
        expect {
          post(:create, transfer: { amount: 0, destination: member_taker.account.id })
        }.not_to change(Transfer, :count)

        expect(response).to redirect_to(referer)
      end
    end
  end
end
