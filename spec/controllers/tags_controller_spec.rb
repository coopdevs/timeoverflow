require 'spec_helper'

describe TagsController do
  include_context "stub browser locale"
  before { set_browser_locale('it') }

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

end
