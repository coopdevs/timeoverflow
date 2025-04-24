RSpec.describe OrganizationAlliance do
  let(:organization) { Fabricate(:organization) }
  let(:other_organization) { Fabricate(:organization) }

  around do |example|
    I18n.with_locale(:en) do
      example.run
    end
  end

  describe "validations" do
    it "is valid with valid attributes" do
      alliance = OrganizationAlliance.new(
        source_organization: organization,
        target_organization: other_organization
      )
      expect(alliance).to be_valid
    end

    it "is not valid without a source organization" do
      alliance = OrganizationAlliance.new(
        source_organization: nil,
        target_organization: other_organization
      )
      expect(alliance).not_to be_valid
      expect(alliance.errors[:source_organization_id]).to include("can't be blank")
    end

    it "is not valid without a target organization" do
      alliance = OrganizationAlliance.new(
        source_organization: organization,
        target_organization: nil
      )
      expect(alliance).not_to be_valid
      expect(alliance.errors[:target_organization_id]).to include("can't be blank")
    end

    it "is not valid if creating an alliance with self" do
      alliance = OrganizationAlliance.new(
        source_organization: organization,
        target_organization: organization
      )
      expect(alliance).not_to be_valid
      expect(alliance.errors[:base]).to include("Cannot create an alliance with yourself")
    end

    it "is not valid if alliance already exists" do
      OrganizationAlliance.create!(
        source_organization: organization,
        target_organization: other_organization
      )

      alliance = OrganizationAlliance.new(
        source_organization: organization,
        target_organization: other_organization
      )
      expect(alliance).not_to be_valid
      expect(alliance.errors[:target_organization_id]).to include("has already been taken")
    end
  end

  describe "status enum" do
    let(:alliance) {
      OrganizationAlliance.create!(
        source_organization: organization,
        target_organization: other_organization
      )
    }

    it "defaults to pending" do
      expect(alliance).to be_pending
    end

    it "can be set to accepted" do
      alliance.accepted!
      expect(alliance).to be_accepted
    end

    it "can be set to rejected" do
      alliance.rejected!
      expect(alliance).to be_rejected
    end
  end

  describe "scopes" do
    before do
      @pending_alliance = OrganizationAlliance.create!(
        source_organization: organization,
        target_organization: other_organization,
        status: "pending"
      )

      @accepted_alliance = OrganizationAlliance.create!(
        source_organization: Fabricate(:organization),
        target_organization: Fabricate(:organization),
        status: "accepted"
      )

      @rejected_alliance = OrganizationAlliance.create!(
        source_organization: Fabricate(:organization),
        target_organization: Fabricate(:organization),
        status: "rejected"
      )
    end

    it "returns pending alliances" do
      expect(OrganizationAlliance.pending).to include(@pending_alliance)
      expect(OrganizationAlliance.pending).not_to include(@accepted_alliance, @rejected_alliance)
    end

    it "returns accepted alliances" do
      expect(OrganizationAlliance.accepted).to include(@accepted_alliance)
      expect(OrganizationAlliance.accepted).not_to include(@pending_alliance, @rejected_alliance)
    end

    it "returns rejected alliances" do
      expect(OrganizationAlliance.rejected).to include(@rejected_alliance)
      expect(OrganizationAlliance.rejected).not_to include(@pending_alliance, @accepted_alliance)
    end
  end
end
