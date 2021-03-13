RSpec.describe ReportsController do
  let (:test_organization) { Fabricate(:organization) }
  let (:member1) { Fabricate(:member, organization: test_organization) }
  let (:member2) { Fabricate(:member, organization: test_organization) }
  let (:inactive_member) { Fabricate(:member, organization: test_organization, active: false) }
  let (:another_member) { Fabricate(:member) }
  let (:test_category) { Fabricate(:category) }
  let! (:active_organization_offers) do
    [member1, member2].map do |member|
      Fabricate(:offer,
                user: member.user,
                organization: member.organization,
                category: test_category)
    end
  end

  before do
    [another_member, inactive_member].map do |member|
      Fabricate(:offer,
                user: member.user,
                organization: member.organization,
                category: test_category)
    end
  end

  context 'with a logged user' do
    before { login(member1.user) }

    describe 'GET #user_list' do
      it 'downloads a csv' do
        get :user_list, params: { format: 'csv' }

        report = Report::Csv::Member.new(test_organization, test_organization.members.active)
        expect(response.body).to match(report.run)
        expect(response.media_type).to eq("text/csv")
      end

      it 'downloads a pdf' do
        get :user_list, params: { format: 'pdf' }

        report = Report::Pdf::Member.new(test_organization, test_organization.members.active)
        expect(response.body).to eq(report.run)
        expect(response.media_type).to eq("application/pdf")
      end
    end

    describe 'GET #post_list' do
      let(:report_posts) { test_organization.posts.of_active_members.group_by(&:category) }

      it 'do NOT show the inactive members' do
        get :post_list, params: { type: 'offer' }

        posts = assigns(:posts)[0][1]
        expect(posts.size).to eq(active_organization_offers.size)
        expect(posts.map(&:id)).to match_array(active_organization_offers.map(&:id))
      end

      it 'downloads a csv' do
        get :post_list, params: { type: 'offer', format: 'csv' }

        report = Report::Csv::Post.new(test_organization, report_posts, Offer)
        expect(response.body).to eq(report.run)
        expect(response.media_type).to eq("text/csv")
      end

      it 'downloads a pdf' do
        get :post_list, params: { type: 'offer', format: 'pdf' }

        report = Report::Pdf::Post.new(test_organization, report_posts, Offer)
        expect(response.body).to eq(report.run)
        expect(response.media_type).to eq("application/pdf")
      end
    end

    describe 'GET #transfer_list' do
      it 'downloads a csv' do
        get :transfer_list, params: { format: 'csv' }

        report = Report::Csv::Transfer.new(test_organization, test_organization.all_transfers)
        expect(response.body).to eq(report.run)
        expect(response.media_type).to eq("text/csv")
      end

      it 'downloads a pdf' do
        get :transfer_list, params: { format: 'pdf' }

        report = Report::Pdf::Transfer.new(test_organization, test_organization.all_transfers)
        expect(response.body).to eq(report.run)
        expect(response.media_type).to eq("application/pdf")
      end
    end
  end
end
