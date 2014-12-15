require "spec_helper"

describe TagsController do
  let (:test_organization) { Fabricate(:organization) }
  let (:member_admin) do
    Fabricate(:member,
              organization: test_organization,
              manager: true)
  end
  let (:member) do
    Fabricate(:member,
              organization: test_organization,
              manager: false)
  end
  let (:another_member) do
    Fabricate(:member,
              organization: test_organization,
              manager: false)
  end
  let! (:user) { member.user }
  let! (:another_user) { another_member.user }
  let! (:admin_user) { member_admin.user }
  include_context "stub browser locale"
  before { set_browser_locale("ca") }
  describe "GET #index" do
    context "with an normal logged user" do
      before { login(user) }
      it "returns http success" do
        get "index"
        response.should be_success
      end
    end
  end
  describe "GET #offers" do
    context "with an normal logged user" do
      before { login(user) }
      subject { get "offers" }
      it "renders grouped_index with list of tags" do
        expect(subject).to render_template("tags/_grouped_index")
      end
    end
  end
  describe "GET #inquiries" do
    context "with an normal logged user" do
      before { login(user) }
      subject { get "inquiries" }
      it "renders grouped_index with list of tags" do
        expect(subject).to render_template("tags/_grouped_index")
      end
    end
  end
end
