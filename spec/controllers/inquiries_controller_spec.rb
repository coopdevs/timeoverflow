require "spec_helper"

describe InquiriesController do
  let (:test_organization) { Fabricate(:organization) }
  let (:member) { Fabricate(:member, organization: test_organization) }
  let (:another_member) { Fabricate(:member, organization: test_organization) }
  let (:test_category) { Fabricate(:category) }
  let! (:inquiry) do
    Fabricate(:inquiry,
              user: member.user,
              organization: test_organization,
              category: test_category)
  end
  include_context "stub browser locale"
  before { set_browser_locale("ca") }

  describe "GET #index" do
    context "with a logged user" do
      it "populates and array of inquiries" do
        login(another_member.user)

        get "index"
        expect(assigns(:inquiries)).to eq([inquiry])
      end
    end
  end

  describe "GET #show" do
    context "with valid params" do
      context "with a logged user" do
        it "assigns the requested inquiry to @inquiry" do
          login(another_member.user)

          get "show", id: inquiry.id
          expect(assigns(:inquiry)).to eq(inquiry)
        end
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      context "with a logged user" do
        it "creates a new inquiry" do
          login(another_member.user)

          expect do
            post "create", inquiry: { user: another_member.user,
                                      category_id: test_category.id,
                                      title: "New title" }
          end.to change(Inquiry, :count).by(1)
        end
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      context "with a logged user" do
        it "located the requested @inquiry" do
          login(member.user)

          put "update", id: inquiry.id, inquiry: Fabricate.to_params(:inquiry)
          expect(assigns(:inquiry)).to eq(inquiry)
        end

        it "changes @inquiry's attributes" do
          login(member.user)

          put "update",
              id: inquiry.id,
              inquiry: Fabricate.to_params(:inquiry,
                                           user: member,
                                           title: "New title",
                                           description: "New description",
                                           tag_list: ["foo"])

          inquiry.reload
          expect(inquiry.title).to eq("New title")
          expect(inquiry.description).to eq("New description")
          expect(inquiry.tags).to include("foo")
        end
      end
    end

    context "with invalid params" do
      context "with a logged user" do
        it "does not change @inquiry's attributes" do
          login(member.user)

          put :update,
              id: inquiry.id,
              inquiry: Fabricate.to_params(:inquiry,
                                           user: nil,
                                           title: "New title",
                                           description: "New description")

          expect(inquiry.title).not_to eq("New title")
          expect(inquiry.description).not_to eq("New description")
        end
      end
    end
  end

  describe "DELETE destroy" do
    it "toggle active field" do
      login(member.user)

      delete :destroy, id: inquiry.id

      inquiry.reload
      expect(inquiry.active).to be false
    end

    it "redirects to inquiries#index" do
      login(member.user)

      delete :destroy, id: inquiry.id
      expect(response).to redirect_to inquiries_url
    end
  end
end
