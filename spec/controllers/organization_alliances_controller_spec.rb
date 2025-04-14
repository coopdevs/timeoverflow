RSpec.describe OrganizationAlliancesController do
  let(:organization) { Fabricate(:organization) }
  let(:other_organization) { Fabricate(:organization) }
  let(:member) { Fabricate(:member, organization: organization, manager: true) }
  let(:user) { member.user }

  before do
    login(user)
  end

  describe "GET #index" do
    let!(:pending_sent) {
      OrganizationAlliance.create!(
        source_organization: organization,
        target_organization: other_organization,
        status: "pending"
      )
    }

    let!(:pending_received) {
      OrganizationAlliance.create!(
        source_organization: Fabricate(:organization),
        target_organization: organization,
        status: "pending"
      )
    }

    let!(:accepted) {
      OrganizationAlliance.create!(
        source_organization: organization,
        target_organization: Fabricate(:organization),
        status: "accepted"
      )
    }

    let!(:rejected) {
      OrganizationAlliance.create!(
        source_organization: organization,
        target_organization: Fabricate(:organization),
        status: "rejected"
      )
    }

    it "lists pending alliances by default" do
      get :index

      expect(assigns(:status)).to eq("pending")
      expect(assigns(:alliances)).to include(pending_sent, pending_received)
      expect(assigns(:alliances)).not_to include(accepted, rejected)
    end

    it "lists accepted alliances when status is accepted" do
      get :index, params: { status: "accepted" }

      expect(assigns(:status)).to eq("accepted")
      expect(assigns(:alliances)).to include(accepted)
      expect(assigns(:alliances)).not_to include(pending_sent, pending_received, rejected)
    end

    it "lists rejected alliances when status is rejected" do
      get :index, params: { status: "rejected" }

      expect(assigns(:status)).to eq("rejected")
      expect(assigns(:alliances)).to include(rejected)
      expect(assigns(:alliances)).not_to include(pending_sent, pending_received, accepted)
    end
  end

  describe "POST #create" do
    it "creates a new alliance" do
      expect {
        post :create, params: { organization_alliance: { target_organization_id: other_organization.id } }
      }.to change(OrganizationAlliance, :count).by(1)

      expect(flash[:notice]).to eq(I18n.t("organization_alliances.created"))
      expect(response).to redirect_to(organizations_path)
    end

    it "sets flash error if alliance cannot be created" do
      # Try to create alliance with self which is invalid
      allow_any_instance_of(OrganizationAlliance).to receive(:save).and_return(false)
      allow_any_instance_of(OrganizationAlliance).to receive_message_chain(:errors, :full_messages, :to_sentence).and_return("Error message")

      post :create, params: { organization_alliance: { target_organization_id: organization.id } }

      expect(flash[:error]).to eq("Error message")
      expect(response).to redirect_to(organizations_path)
    end
  end

  describe "PUT #update" do
    let!(:alliance) {
      OrganizationAlliance.create!(
        source_organization: Fabricate(:organization),
        target_organization: organization,
        status: "pending"
      )
    }

    it "updates alliance status to accepted" do
      put :update, params: { id: alliance.id, status: "accepted" }

      alliance.reload
      expect(alliance).to be_accepted
      expect(flash[:notice]).to eq(I18n.t("organization_alliances.updated"))
      expect(response).to redirect_to(organization_alliances_path)
    end

    it "updates alliance status to rejected" do
      put :update, params: { id: alliance.id, status: "rejected" }

      alliance.reload
      expect(alliance).to be_rejected
      expect(flash[:notice]).to eq(I18n.t("organization_alliances.updated"))
      expect(response).to redirect_to(organization_alliances_path)
    end

    it "sets flash error if alliance cannot be updated" do
      allow_any_instance_of(OrganizationAlliance).to receive(:update).and_return(false)
      allow_any_instance_of(OrganizationAlliance).to receive_message_chain(:errors, :full_messages, :to_sentence).and_return("Error message")

      put :update, params: { id: alliance.id, status: "accepted" }

      expect(flash[:error]).to eq("Error message")
      expect(response).to redirect_to(organization_alliances_path)
    end
  end

  describe "DELETE #destroy" do
    let!(:alliance) {
      OrganizationAlliance.create!(
        source_organization: organization,
        target_organization: other_organization
      )
    }

    it "destroys the alliance" do
      expect {
        delete :destroy, params: { id: alliance.id }
      }.to change(OrganizationAlliance, :count).by(-1)

      expect(flash[:notice]).to eq(I18n.t("organization_alliances.destroyed"))
      expect(response).to redirect_to(organization_alliances_path)
    end

    it "sets flash error if alliance cannot be destroyed" do
      allow_any_instance_of(OrganizationAlliance).to receive(:destroy).and_return(false)

      delete :destroy, params: { id: alliance.id }

      expect(flash[:error]).to eq(I18n.t("organization_alliances.error_destroying"))
      expect(response).to redirect_to(organization_alliances_path)
    end
  end
end
