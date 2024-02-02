RSpec.describe SessionsController do
  let(:user) { Fabricate(:user, password: "papapa22", password_confirmation: "papapa22") }

  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "#create" do
    it "does not show a notice flash message" do
      post :create, params: { user: { email: user.email, password: user.password } }

      expect(flash[:notice]).to be_nil
    end

    it "redirects to the previous page" do
      session["user_return_to"] = offers_path

      post :create, params: { user: { email: user.email, password: user.password } }

      expect(response).to redirect_to(offers_path)
    end
  end

  describe "#destroy" do
    before do
      post :create, params: { user: { email: user.email, password: user.password } }
    end

    it "does not show a notice flash message" do
      delete :destroy

      expect(flash[:notice]).to be_nil
    end
  end
end
