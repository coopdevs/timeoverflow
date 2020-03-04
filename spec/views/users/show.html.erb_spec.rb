require 'spec_helper'

RSpec.describe 'users/show' do
    let(:test_organization) { Fabricate(:organization) }
    let(:member_admin) do
        Fabricate(:member,
         organization: test_organization,
          manager: true)
    end
    let(:member) do
    Fabricate(:member,
              organization: test_organization,
              manager: false)
    end
    let(:another_member) do
    Fabricate(:member,
              organization: test_organization,
              manager: false)
    end
    let(:wrong_email_member) do
    Fabricate(:member,
              organization: test_organization,
              manager: false)
    end
    let(:empty_email_member) do
    Fabricate(:member,
              organization: test_organization,
              manager: false)
    end

    let(:offer) { Fabricate(:offer, user: member.user) }

    let(:destination_account) { Fabricate(:account) }

    let!(:user) { member.user }
    let!(:another_user) { another_member.user }
    let!(:admin_user) { member_admin.user }
    let!(:wrong_user) { wrong_email_member.user }
    let!(:empty_email_user) { empty_email_member.user }

    it 'renders a link to new_transfer_path for their individual offers' do
        assign :offer, offer
        assign :destination_account, destination_account
        render template: 'users/show'

        expect(rendered).to have_link(
            t('users.show.give_time'),
            href: new_transfer_path(
                id: offer.user.id,
                destination_account_id: destination_account.id,
                offer: offer.id
            )
        )
    end      
end