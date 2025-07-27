RSpec.describe OrganizationTransfersController do
  let(:source_organization) { Fabricate(:organization) }
  let(:target_organization) { Fabricate(:organization) }
  let(:manager) { Fabricate(:member, organization: source_organization, manager: true) }
  let(:user) { manager.user }

  let!(:alliance) do
    OrganizationAlliance.create!(
      source_organization: source_organization,
      target_organization: target_organization,
      status: "accepted"
    )
  end

  before do
    login(user)
    session[:current_organization_id] = source_organization.id
    controller.instance_variable_set(:@current_organization, source_organization)
  end

  describe "GET #new" do
    it "assigns a new transfer and sets organizations" do
      get :new, params: { destination_organization_id: target_organization.id }

      expect(response).to be_successful
      expect(assigns(:transfer)).to be_a_new(Transfer)
      expect(assigns(:source_organization)).to eq(source_organization)
      expect(assigns(:destination_organization)).to eq(target_organization)
    end

    context "when user is not a manager" do
      let(:regular_member) { Fabricate(:member, organization: source_organization) }

      before do
        login(regular_member.user)
      end

      it "redirects to root path" do
        get :new, params: { destination_organization_id: target_organization.id }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('organization_alliances.not_authorized'))
      end
    end

    context "when destination organization not found" do
      it "redirects to organizations path" do
        get :new, params: { destination_organization_id: 999 }

        expect(response).to redirect_to(organizations_path)
        expect(flash[:alert]).to eq(I18n.t('application.tips.user_not_found'))
      end
    end

    context "when no alliance exists between organizations" do
      let(:other_organization) { Fabricate(:organization) }

      it "redirects to organizations path" do
        get :new, params: { destination_organization_id: other_organization.id }

        expect(response).to redirect_to(organizations_path)
        expect(flash[:alert]).to eq(I18n.t('activerecord.errors.models.transfer.attributes.base.no_alliance_between_organizations'))
      end
    end

    context "when alliance is pending" do
      let(:pending_organization) { Fabricate(:organization) }
      let!(:pending_alliance) do
        OrganizationAlliance.create!(
          source_organization: source_organization,
          target_organization: pending_organization,
          status: "pending"
        )
      end

      it "redirects to organizations path" do
        get :new, params: { destination_organization_id: pending_organization.id }

        expect(response).to redirect_to(organizations_path)
        expect(flash[:alert]).to eq(I18n.t('activerecord.errors.models.transfer.attributes.base.no_alliance_between_organizations'))
      end
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new transfer and redirects to organization path" do
        persister_double = instance_double(::Persister::TransferPersister, save: true)
        allow(::Persister::TransferPersister).to receive(:new).and_return(persister_double)

        expect {
          post :create, params: {
            destination_organization_id: target_organization.id,
            transfer: { hours: 2, minutes: 30, reason: "Testing alliance", amount: 150 }
          }
        }.not_to raise_error

        expect(response).to redirect_to(organization_path(target_organization))
        expect(flash[:notice]).to eq(I18n.t('organizations.transfers.create.success'))
      end
    end

    context "with invalid parameters" do
      it "renders the new template with errors" do
        transfer_double = instance_double(Transfer)
        persister_double = instance_double(::Persister::TransferPersister, save: false)

        allow(Transfer).to receive(:new).and_return(transfer_double)
        allow(transfer_double).to receive(:source=)
        allow(transfer_double).to receive(:destination=)
        allow(transfer_double).to receive(:post=)
        error_messages = ["Amount can't be zero"]
        allow(transfer_double).to receive(:errors).and_return(
          instance_double("ActiveModel::Errors", full_messages: error_messages)
        )
        allow(::Persister::TransferPersister).to receive(:new).and_return(persister_double)

        expect(controller).to receive(:render).with(:new)

        post :create, params: {
          destination_organization_id: target_organization.id,
          transfer: { hours: 0, minutes: 0, reason: "", amount: 0 }
        }

        expect(flash[:error]).to include("Amount can't be zero")
      end
    end

    context "when user is not a manager" do
      let(:regular_member) { Fabricate(:member, organization: source_organization) }

      before do
        login(regular_member.user)
      end

      it "redirects to root path" do
        post :create, params: {
          destination_organization_id: target_organization.id,
          transfer: { hours: 1, minutes: 0, reason: "Test", amount: 60 }
        }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('organization_alliances.not_authorized'))
      end
    end

    context "when no alliance exists between organizations" do
      let(:other_organization) { Fabricate(:organization) }

      it "redirects to organizations path" do
        post :create, params: {
          destination_organization_id: other_organization.id,
          transfer: { hours: 1, minutes: 0, reason: "Test", amount: 60 }
        }

        expect(response).to redirect_to(organizations_path)
        expect(flash[:alert]).to eq(I18n.t('activerecord.errors.models.transfer.attributes.base.no_alliance_between_organizations'))
      end
    end
  end
end
