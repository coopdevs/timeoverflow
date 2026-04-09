RSpec.describe Admin::UsersController, type: :controller do
  let(:organization) { Fabricate(:organization) }
  let(:member) { Fabricate(:member, organization: organization) }
  let(:user) { member.user }

  before do
    login(user)
    allow(controller).to receive(:authenticate_superuser!).and_return(true)
  end

  describe "PUT #confirm" do
    context "when the user is unconfirmed" do
      let(:unconfirmed_user) { Fabricate(:user, confirmed_at: nil) }

      it "confirms the user and redirects with notice" do
        put :confirm, params: { id: unconfirmed_user.id }

        expect(unconfirmed_user.reload.confirmed?).to be true
        expect(response).to redirect_to(admin_user_path(unconfirmed_user))
        expect(flash[:notice]).to eq(I18n.t("active_admin.users.confirmed_notice"))
      end
    end

    context "when the user is already confirmed" do
      it "re-confirms and redirects with notice" do
        put :confirm, params: { id: user.id }

        expect(response).to redirect_to(admin_user_path(user))
        expect(flash[:notice]).to eq(I18n.t("active_admin.users.confirmed_notice"))
      end
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      { username: "newuser", email: "new@example.com", locale: "en" }
    end

    context "with confirm_immediately checked" do
      it "creates a confirmed user" do
        post :create, params: { user: valid_params.merge(confirm_immediately: "1") }

        created_user = User.find_by(email: "new@example.com")
        expect(created_user).to be_confirmed
      end
    end

    context "without confirm_immediately checked" do
      it "creates an unconfirmed user" do
        post :create, params: { user: valid_params.merge(confirm_immediately: "0") }

        created_user = User.find_by(email: "new@example.com")
        expect(created_user).not_to be_confirmed
      end
    end
  end

  describe "PUT #update" do
    context "when password is blank" do
      it "does not change the existing password" do
        original_encrypted = user.encrypted_password

        put :update, params: { id: user.id, user: { password: "", password_confirmation: "" } }

        expect(user.reload.encrypted_password).to eq(original_encrypted)
      end
    end

    context "when password is provided" do
      it "updates the password" do
        original_encrypted = user.encrypted_password

        put :update, params: { id: user.id, user: { password: "newpassword123", password_confirmation: "newpassword123" } }

        expect(user.reload.encrypted_password).not_to eq(original_encrypted)
      end
    end
  end
end
