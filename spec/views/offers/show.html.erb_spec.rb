require 'spec_helper'

describe 'offers/show' do
  let(:organization) { Fabricate(:organization) }
  let(:member) { Fabricate(:member, organization: organization) }
  let(:offer) { Fabricate(:offer, user: member.user, organization: organization) }
  let(:destination_account) { Fabricate(:account) }

  before do
    allow(view).to receive(:admin?).and_return(false)
    allow(view).to receive(:current_organization) { organization }

    allow(offer).to receive(:member).and_return(member)
  end

  context 'when there is logged in' do
    let(:logged_user) { Fabricate(:user) }

    before do
      Fabricate(
        :member,
        organization: organization,
        user: logged_user
      )

      allow(view).to receive(:current_user).and_return(logged_user)
    end

    it 'renders a link to the transfer page' do
      assign :offer, offer
      assign :destination_account, destination_account
      render template: 'offers/show'

      expect(rendered).to have_link(
        t('offers.show.give_time_for'),
        href: new_transfer_path(
          id: offer.user.id,
          offer: offer.id,
          destination_account_id: destination_account.id
        )
      )
    end
  end

  context 'where is a guest user' do
    before do
      allow(view).to receive(:current_user).and_return(nil)
    end

    it 'does not render a link to the transfer page' do
      assign :offer, offer
      assign :destination_account, destination_account
      render template: 'offers/show'

      expect(rendered).not_to have_link(
        t('offers.show.give_time_for'),
        href: new_transfer_path(
          id: offer.user.id,
          offer: offer.id,
          destination_account_id: destination_account.id
        )
      )
    end

    it 'renders a link to the login page' do
      assign :offer, offer
      render template: 'offers/show'

      expect(rendered).to have_link(
        t('layouts.application.login'),
        href: new_user_session_path
      )
    end
  end
end
