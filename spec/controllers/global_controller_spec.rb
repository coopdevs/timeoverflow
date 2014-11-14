require 'spec_helper'

describe GlobalController do

  describe "GET 'switch_lang'" do
    it "returns http success" do
      get 'switch_lang'
      response.should be_success
    end
  end

end
