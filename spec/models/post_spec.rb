RSpec.describe Post do
  describe "Relations" do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:transfers) }
    it { is_expected.to have_many(:movements) }
    it { is_expected.to have_many(:events) }
  end
end
