require "spec_helper"

describe OffersController, type: :controller do
  let(:test_organization) { Fabricate(:organization) }
  let(:member) { Fabricate(:member, organization: test_organization) }
  let(:another_member) { Fabricate(:member, organization: test_organization) }
  let(:yet_another_member) { Fabricate(:member) }
  let(:test_category) { Fabricate(:category) }
  let!(:offer) do
    Fabricate(:offer,
              user: member.user,
              organization: test_organization,
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
    context 'when there is a matching active offer' do
      before do
        # Force the index to exist
        Offer.__elasticsearch__.create_index!(force: true)

        # Import any already existing model into the index
        # for instance the ones that have been created in upper
        # `let!` or `before` blocks
        Offer.__elasticsearch__.import(force: true, refresh: true)

        login(another_member.user)
      end

      it "populates an array of offers" do
        get "index", q: offer.title.split(/\s/).first

        # @offers is a wrapper from Elasticsearch. It's iterator-equivalent to
        # the underlying query from the database.
        expect(assigns(:offers)).to be_a Elasticsearch::Model::Response::Records
        expect(assigns(:offers).to_a).to eq([offer])
      end
    end

    context 'when there is a matching non active offer' do
      before do
        non_active_offer

        # Force the index to exist
        Offer.__elasticsearch__.create_index!(force: true)

        # Import any already existing model into the index
        # for instance the ones that have been created in upper
        # `let!` or `before` blocks
        Offer.__elasticsearch__.import(force: true, refresh: true)

        login(another_member.user)
      end

      let(:non_active_offer) do
        Fabricate(
          :offer,
          title: offer.title,
          user: member.user,
          organization: test_organization,
          category: test_category,
          active: false
        )
      end

      it 'does not show up on the search results' do
        get "index", q: offer.title.split(/\s/).first
        expect(assigns(:offers).to_a).to contain_exactly(offer)
      end
    end
  end

  describe "GET #show" do
    context "with valid params" do
      context "with a logged user" do
        it "assigns the requested offer to @offer" do
          login(another_member.user)

          get "show", id: offer.id
          expect(assigns(:offer)).to eq(offer)
        end
      end
      context "without a logged in user" do
        it "assigns the requested offer to @offer" do
          get "show", id: offer.id
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
