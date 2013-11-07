require 'spec_helper'

describe InquiriesController do
  let (:test_organization) { Fabricate(:organization)}
  let (:member) { Fabricate(:member, organization: test_organization)}
  let (:another_member) { Fabricate(:member, organization: test_organization)}
  let! (:inquiry) { Fabricate(:inquiry, user: member.user)}

  describe "GET #index" do
    context "with a logged user" do
      it "populates and array of inquiries" do
        login(another_member.user)

        get :index
        expect(assigns(:inquiries)).to eq([inquiry])
      end
    end
  end

  describe "GET #show" do
    context "with a logged user" do
      it "assigns the requested inquiry to @inquiry" do
        login(another_member.user)

        get :show, id: inquiry.id
        expect(assigns(:inquiry)).to eq(inquiry)
      end
    end
  end
end
