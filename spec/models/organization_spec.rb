RSpec.describe Organization do
  let(:organization) { Fabricate(:organization) }

  describe "logo validation" do
    it "validates content_type" do
      temp_file = Tempfile.new('test.txt')
      organization.logo.attach(io: File.open(temp_file.path), filename: 'test.txt')
      expect(organization).to be_invalid

      temp_file = Tempfile.new('test.svg')
      organization.logo.attach(io: File.open(temp_file.path), filename: 'test.svg')
      expect(organization).to be_invalid

      temp_file = Tempfile.new('test.png')
      organization.logo.attach(io: File.open(temp_file.path), filename: 'test.png')
      expect(organization).to be_valid
    end
  end

  describe '#display_id' do
    subject { organization.display_id }
    it { is_expected.to eq(organization.account.accountable_id) }
  end

  describe 'ensure_url validation' do
    it "without http & https" do
      organization.web = "www.casa.com"
      expect(organization).to be_valid
      expect(organization.web).to eq "http://www.casa.com"
    end

    it "with http" do
      organization.web = "http://www.casa.com"
      expect(organization).to be_valid
      expect(organization.web).to eq "http://www.casa.com"
    end

    it "with https" do
      organization.web = "https://www.casa.com"
      expect(organization).to be_valid
      expect(organization.web).to eq "https://www.casa.com"
    end

    it "with blank value" do
      organization.web = ""
      expect(organization).to be_valid
      expect(organization.web).to eq ""
    end

    it "with nil value" do
      organization.web = nil
      expect(organization).to be_valid
      expect(organization.web).to eq nil
    end

    it "with an invalid" do
      organization.web = "la casa"
      expect(organization).not_to be_valid
      expect(organization.web).to eq "la casa"
      expect(organization.errors.size).to eq 1
    end
  end

  it 'name is mandatory' do
    organization.name = nil
    organization.save
    expect(organization.errors[:name]).to include(I18n.t('errors.messages.blank'))
  end

  describe "alliance methods" do
    let(:organization) { Fabricate(:organization) }
    let(:other_organization) { Fabricate(:organization) }

    describe "#alliance_with" do
      it "returns nil if no alliance exists" do
        expect(organization.alliance_with(other_organization)).to be_nil
      end

      it "returns alliance when organization is source" do
        alliance = OrganizationAlliance.create!(
          source_organization: organization,
          target_organization: other_organization
        )

        expect(organization.alliance_with(other_organization)).to eq(alliance)
      end

      it "returns alliance when organization is target" do
        alliance = OrganizationAlliance.create!(
          source_organization: other_organization,
          target_organization: organization
        )

        expect(organization.alliance_with(other_organization)).to eq(alliance)
      end
    end

    describe "alliance status methods" do
      let(:third_organization) { Fabricate(:organization) }

      before do
        @pending_sent = OrganizationAlliance.create!(
          source_organization: organization,
          target_organization: other_organization,
          status: "pending"
        )

        @pending_received = OrganizationAlliance.create!(
          source_organization: third_organization,
          target_organization: organization,
          status: "pending"
        )

        @accepted_sent = OrganizationAlliance.create!(
          source_organization: organization,
          target_organization: Fabricate(:organization),
          status: "accepted"
        )

        @accepted_received = OrganizationAlliance.create!(
          source_organization: Fabricate(:organization),
          target_organization: organization,
          status: "accepted"
        )

        @rejected_sent = OrganizationAlliance.create!(
          source_organization: organization,
          target_organization: Fabricate(:organization),
          status: "rejected"
        )

        @rejected_received = OrganizationAlliance.create!(
          source_organization: Fabricate(:organization),
          target_organization: organization,
          status: "rejected"
        )
      end

      it "returns pending sent alliances" do
        expect(organization.pending_sent_alliances).to include(@pending_sent)
        expect(organization.pending_sent_alliances).not_to include(@pending_received)
      end

      it "returns pending received alliances" do
        expect(organization.pending_received_alliances).to include(@pending_received)
        expect(organization.pending_received_alliances).not_to include(@pending_sent)
      end

      it "returns accepted alliances" do
        expect(organization.accepted_alliances).to include(@accepted_sent, @accepted_received)
        expect(organization.accepted_alliances).not_to include(
          @pending_sent, @pending_received, @rejected_sent, @rejected_received
        )
      end

      it "returns rejected alliances" do
        expect(organization.rejected_alliances).to include(@rejected_sent, @rejected_received)
        expect(organization.rejected_alliances).not_to include(
          @pending_sent, @pending_received, @accepted_sent, @accepted_received
        )
      end
    end
  end
end
