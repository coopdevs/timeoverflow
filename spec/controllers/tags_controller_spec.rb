require 'spec_helper'

describe TagsController do
  let (:tags) { %w(foo bar baz) }
  let (:organization) { Fabricate(:organization) }
  let (:member) { Fabricate(:member, organization: organization) }
  let! (:post) { Fabricate(:offer,
                          user: member.user,
                          organization: organization,
                          tags: tags) }

  describe "GET 'index'" do
    before(:each) do
      login(member.user)
    end

    it "returns http success" do
      get 'index'
      expect(response).to be_success
      expect(response.content_type).to eq("application/json")
    end

    it "with no search term, returns all tags" do
      get 'index'
      expect(assigns(:all_tags)).to eq(tags)
    end

    it "with search term, returns filtered tags" do
      get 'index', term: "foo"
      expect(assigns(:all_tags)).to eq(["foo"])
    end
  end
end
