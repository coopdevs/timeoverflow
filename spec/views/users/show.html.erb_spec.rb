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
    let!(:admin_user) { member_admin.user }


    let(:logged_user) { Fabricate(:user) }

    before do
        allow(view).to receive(:admin?).and_return(false)
    end
    

    it 'renders a link to new_transfer_path for their individual offers' do
        assign :destination_account, destination_account
        assign :user, user
        assign :member, member
        assign :offer, offer
        assign :offers, member.user.offers.active
        assign :movements, member.movements.page

        allow(view).to receive(:current_user).and_return(logged_user)
        
        render template: 'users/show'

        #expect(rendered).to have_selector("//a", text: "/transfers/new?destination_account_id=#{member.account.id}&amp;id=#{user.id}&amp;offer=#{offer.id}")
        
        byebug
        expect(rendered).to have_link(
            nil,
            href: new_transfer_path(
                id: user.id,
                destination_account_id: member.account.id,
                offer: offer.id
            )
        ) 
            
     end
end