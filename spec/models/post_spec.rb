RSpec.describe Post do
  describe 'Relations' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:transfers) }
    it { is_expected.to have_many(:movements) }
    it { is_expected.to have_many(:events) }
  end

  describe '.by_organizations' do
    let(:organization) { Fabricate(:organization) }
    let(:other_organization) { Fabricate(:organization) }
    let(:member) { Fabricate(:member, organization: organization) }
    let(:other_member) { Fabricate(:member, organization: other_organization) }
    let(:category) { Fabricate(:category) }
    let!(:post1) { Fabricate(:offer, user: member.user, organization: organization, category: category) }
    let!(:post2) { Fabricate(:offer, user: other_member.user, organization: other_organization, category: category) }

    it 'returns posts from the specified organizations' do
      expect(Post.by_organizations([organization.id])).to include(post1)
      expect(Post.by_organizations([organization.id])).not_to include(post2)

      expect(Post.by_organizations([other_organization.id])).to include(post2)
      expect(Post.by_organizations([other_organization.id])).not_to include(post1)

      expect(Post.by_organizations([organization.id, other_organization.id])).to include(post1, post2)
    end

    it 'returns all posts if no organization ids are provided' do
      expect(Post.by_organizations(nil)).to include(post1, post2)
      expect(Post.by_organizations([])).to include(post1, post2)
    end
  end
end
