require 'spec_helper'

RSpec.describe 'inquiries/show' do
  let(:organization) { Fabricate(:organization) }
  let(:member) { Fabricate(:member, organization: organization) }
  let(:inquiry) { Fabricate(:inquiry, user: member.user, organization: organization) }
  let(:group_inquiry) { Fabricate(:inquiry, user: member.user, organization: organization, is_group: true) }
  let(:destination_account) { Fabricate(:account) }


  context 'when the user is not logged in' do
    before do
      allow(view).to receive(:current_user).and_return(nil)
      allow(view).to receive(:current_organization).and_return(nil)
    end

    context 'when it is not a group inquiry' do
      it 'displays a label' do
        assign :inquiry, inquiry
        assign :destination_account, destination_account
        render template: 'inquiries/show'

        expect(rendered).to_not include(I18n.t('activerecord.attributes.inquiry.is_group'))
      end
    end

    context 'when it is a group inquiry' do
      it 'displays a label' do
        assign :inquiry, group_inquiry
        assign :destination_account, destination_account
        render template: 'inquiries/show'

        expect(rendered).to include(I18n.t('activerecord.attributes.inquiry.is_group'))
      end
    end
  end
end
