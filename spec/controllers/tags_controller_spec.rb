RSpec.describe TagsController do
  let (:tags) { %w(foo bar baz) }
  let (:more_tags) { %w(ruby rails js) }
  let (:member_tags) { %w(html html css html5) }
  let (:organization) { Fabricate(:organization) }
  let (:member) { Fabricate(:member, organization: organization, tags: member_tags) }
  let! (:offer) { Fabricate(:offer, user: member.user, organization: organization, tags: tags) }
  let! (:inquiry) { Fabricate(:inquiry, user: member.user, organization: organization, tags: more_tags) }

  before(:each) do
    login(member.user)
  end

  describe "GET index" do
    it "returns json and http success" do
      get :index, params: { model: "post" }

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match("application/json")
    end

    it "with no search term, returns all tags" do
      get :index, params: { model: "post" }

      expect(assigns(:tags)).to eq(more_tags + tags)
    end

    it "with search term, returns filtered tags" do
      get :index, params: { model: "post", term: "foo" }

      expect(assigns(:tags)).to eq(["foo"])
    end

    context "for members" do
      it "with no search term, returns all members tags" do
        get :index, params: { model: "member" }

        expect(assigns(:tags)).to eq(member_tags.uniq)
      end

      it "with search term, returns filtered members tags" do
        get :index, params: { model: "member", term: "htm" }

        expect(assigns(:tags)).to eq(%w(html html5))
      end
    end
  end

  describe "GET alpha_grouped_index" do
    before { session[:current_organization_id] = organization.id }

    it "load offers tags by default if no type is passed" do
      get :alpha_grouped_index

      expect(assigns(:tags)).to eq({
        "B" => [["bar", 1], ["baz", 1]],
        "F" => [["foo", 1]]
      })
    end

    it "load tags by type" do
      get :alpha_grouped_index, params: { post_type: "inquiry" }

      expect(assigns(:tags)).to eq({
        "J" => [["js", 1]],
        "R" => [["rails", 1], ["ruby", 1]]
      })
    end

    it "load member tags" do
      get :alpha_grouped_index, params: { post_type: "user" }

      expect(assigns(:tags)).to eq({
        "H" => [["html", 2], ["html5", 1]],
        "C" => [["css", 1]]
      })
    end

    it "renders a partial with format js" do
      get :alpha_grouped_index, xhr: true

      expect(response).to render_template(partial: "_grouped_index")
    end
  end
end
