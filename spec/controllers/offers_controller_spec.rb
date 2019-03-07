require "spec_helper"

RSpec.describe OffersController, type: :controller do
  let(:organization) { Fabricate(:organization) }
  let(:member) { Fabricate(:member, organization: organization) }
  let(:another_member) { Fabricate(:member, organization: organization) }
  let(:yet_another_member) { Fabricate(:member) }
  let(:test_category) { Fabricate(:category) }
  let!(:offer) do
    Fabricate(:offer,
              user: member.user,
              organization: organization,
              category: test_category)
  end

  include_context "stub browser locale"

  before { set_browser_locale("ca") }

  describe "GET #index" do
    context "with a logged user" do
      it "populates an array of offers" do
        login(another_member.user)

        get "index"
        expect(assigns(:offers)).to eq([offer])
      end
    end
    context "with another organization" do
      it "skips the original org's offers" do
        login(yet_another_member.user)
        get "index"
        expect(assigns(:offers)).to eq([])
      end
    end
  end

  describe "GET #index (search)" do
    before { login(another_member.user) }

    it "populates an array of offers" do
      get "index", q: offer.title.split(/\s/).first

      expect(assigns(:offers).size).to eq 1
      expect(assigns(:offers)[0]).to eq offer
      expect(assigns(:offers).to_a).to eq([offer])
    end

    it "allows to search by partial word" do
      get :index, q: offer.title.split(/\s/).first[0..-2]

      expect(assigns(:offers)).to include offer
    end
  end

  describe 'GET #show' do
    context 'when the user is logged in' do
      before { login(another_member.user) }

      context 'when the requested offer' do
        context 'is not active' do
          before do
            offer.active = false
            offer.save!
          end

          it 'renders the 404 page' do
            get :show, id: offer.id
            expect(response.status).to eq(404)
          end
        end

        context 'is active' do
          context 'and the user that created the offer is not active anymore' do
            before do
              member.active = false
              member.save!
            end

            it 'renders the 404 page' do
              get :show, id: offer.id
              expect(response.status).to eq(404)
            end
          end

          context 'and the user that created the offer is active' do
            it 'renders a successful response' do
              get :show, id: offer.id
              expect(response.status).to eq(200)
            end

            it 'assigns the requested offer to @offer' do
              get :show, id: offer.id
              expect(assigns(:offer)).to eq(offer)
            end

            it 'assigns the account destination of the transfer' do
              get :show, id: offer.id
              expect(assigns(:destination_account)).to eq(member.account)
            end

            it 'displays the offer\'s user details' do
              get :show, id: offer.id
              expect(response.body).to include(offer.user.email)
            end
          end
        end
      end

      context 'when the user pertains to multiple organizations' do
        context 'and user\'s current organization is different than offer\'s organization' do
          let(:another_organization) { Fabricate(:organization) }

          before do
            Fabricate(:member, user: another_member.user, organization: another_organization)
            allow(controller).to receive(:@current_organization).and_return(another_organization)
          end

          it 'displays the offer\'s user details' do
            get :show, id: offer.id
            expect(response.body).to include(offer.user.email)
          end

          it 'sets the offer\'s organization as user\'s current organization' do
            get :show, id: offer.id
            expect(session[:current_organization_id]).to eq(offer.organization_id)
            expect(assigns(:current_organization)).to eq(offer.organization)
          end
        end
      end
    end

    context 'when the user is not a member of the organization where the offer is published' do
      let(:another_user) { Fabricate(:user) }

      before { login(another_user) }

      it 'doesn\'t display the offer\'s user details' do
        get :show, id: offer.id
        expect(response.body).to_not include(offer.user.email)
      end
    end

    context 'when the user is not logged in' do
      it 'assigns the requested offer to @offer' do
        get :show, id: offer.id
        expect(assigns(:offer)).to eq(offer)
      end

      it 'doesn\'t display the offer\'s user details' do
        get :show, id: offer.id
        expect(response.body).to_not include(offer.user.email)
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      context "with a logged user" do
        it "creates a new offer" do
          login(another_member.user)

          expect do
            post "create", offer: { user: another_member.user,
                                    category_id: test_category,
                                    title: "New title" }
          end.to change(Offer, :count).by(1)
        end
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      context "with a logged user" do
        it "located the requested @offer" do
          login(member.user)

          put "update", id: offer.id, offer: Fabricate.to_params(:offer)
          expect(assigns(:offer)).to eq(offer)
        end

        it "changes @offer's attributes" do
          login(member.user)

          put "update",
              id: offer.id,
              offer: Fabricate.to_params(:offer,
                                         user: member,
                                         title: "New title",
                                         description: "New description",
                                         tag_list: ["foo"])

          offer.reload
          expect(offer.title).to eq("New title")
          expect(offer.description).to eq("New description")
          expect(offer.tags).to include("foo")
        end
      end
    end

    context "with invalid params" do
      context "with a logged user" do
        it "does not change @offer's attributes" do
          login(member.user)

          put :update,
              id: offer.id,
              offer: Fabricate.to_params(:offer,
                                         user: nil,
                                         title: "New title",
                                         description: "New description")

          expect(offer.title).not_to eq("New title")
          expect(offer.description).not_to eq("New description")
        end
      end
    end
  end

  describe "DELETE destroy" do
    it "toggle active field" do
      login(member.user)

      delete :destroy, id: offer.id

      offer.reload
      expect(offer.active).to be false
    end

    it "redirects to offers#index" do
      login(member.user)

      delete :destroy, id: offer.id
      expect(response).to redirect_to offers_url
    end
  end
end
