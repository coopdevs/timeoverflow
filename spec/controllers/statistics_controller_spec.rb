RSpec.describe StatisticsController do
  let(:organization) { Fabricate(:organization) }
  let(:user) { Fabricate(:user, date_of_birth: '1980-1-1', gender: 'others') }
  let(:member) { Fabricate(:member, organization: organization, user: user) }

  before(:each) { login(member.user) }

  describe 'GET #all_transfers' do
    it 'populates all transfers from current organization' do
      transfer = Fabricate(:transfer, source: organization.account, destination: member.account)
      transfer2 = Fabricate(:transfer)

      get :all_transfers

      expect(assigns(:transfers)).to eq([transfer])
    end
  end

  describe 'GET #global_activity' do
    it 'populates some variables' do
      2.times { Fabricate(:transfer, source: organization.account, destination: member.account) }

      get :global_activity

      expect(assigns(:num_swaps)).to eq(2)
      expect(assigns(:total_hours)).to eq(20)
    end
  end

  describe 'GET #type_swaps' do
    it 'populates offers variable' do
      category = Fabricate(:category)
      Fabricate(:offer, organization: organization, user: member.user, category: category, tag_list: ["foo"])
      Fabricate(:transfer, source: organization.account, destination: member.account, post: Offer.all.sample)

      get :type_swaps

      expect(assigns(:offers)).to eq([
        [category.name, "foo", 10, 1, 1.0]
      ])
    end
  end

  describe 'GET #demographics' do
    it 'populates age_counts and gender_counts variables' do
      get :demographics

      expect(assigns(:age_counts)).to eq({ "35-44" => 1 })
      expect(assigns(:gender_counts)).to eq({ "Otro" => 1 })
    end
  end
end
