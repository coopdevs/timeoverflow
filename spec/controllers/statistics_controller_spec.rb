RSpec.describe StatisticsController do
  let(:organization) { Fabricate(:organization) }
  let(:member) { Fabricate(:member, organization: organization) }

  before(:each) { login(member.user) }

  describe '#all_transfers' do
    it 'populates all transfers from current organization' do
      transfer = Fabricate(:transfer, source: organization.account, destination: member.account)
      transfer2 = Fabricate(:transfer)

      get :all_transfers

      expect(assigns(:transfers)).to eq([transfer])
    end
  end
end
