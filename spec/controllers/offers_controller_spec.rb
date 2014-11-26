require 'spec_helper'

describe OffersController do
  let (:test_organization) { Fabricate(:organization)}
  let (:member) { Fabricate(:member, organization: test_organization)}
  let (:another_member) { Fabricate(:member, organization: test_organization)}
  let! (:offer) { Fabricate(:offer, user: member.user, organization: test_organization)}
  include_context "stub browser locale"
  before { set_browser_locale('ca') }

  describe "GET #index" do
    context "with a logged user" do
      it "populates and array of offers" do
        login(another_member.user)

        get 'index'
        expect(assigns(:offers)).to eq([offer])
      end
    end
  end


  describe "GET #show" do
    context "with valid params" do
      context "with a logged user" do
        it "assigns the requested offer to @offer" do
          login(another_member.user)

          get 'show', id: offer.id
          expect(assigns(:offer)).to eq(offer)
        end
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      context "with a logged user" do
        it "creates a new offer" do
          login(another_member.user)

          expect {
            post 'create', offer: Fabricate.to_params(:offer)
          }.to change(Offer,:count).by(1)
        end
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      context "with a logged user" do
        it "located the requested @offer" do
          login(member.user)

          put 'update', id: offer.id, offer: Fabricate.to_params(:offer)
          expect(assigns(:offer)).to eq(offer)
        end

        it "changes @offer's attributes" do
          login(member.user)

          put 'update', id: offer.id, offer: Fabricate.to_params(:offer, user: member, title: "New title", description: "New description")

          offer.reload
          expect(offer.title).to eq("New title")
          expect(offer.description).to eq("New description")
        end
      end
    end

    context "with invalid params" do
      context "with a logged user" do
        it "does not change @offer's attributes" do
          login(member.user)

          put :update, id: offer.id, offer: Fabricate.to_params(:offer, user: nil, title: "New title", description: "New description")

          expect(offer.title).not_to eq("New title")
          expect(offer.description).not_to eq("New description")
        end
      end
    end
  end

end
