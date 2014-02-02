require 'spec_helper'

describe Devise::SessionsController do
  include Devise::TestHelpers
  render_views

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in Fabricate(:member, organization: test_organization)
  end

  it 'should do something' do
    get "new"

    expect(response.body).not_to match "translation-missing"
  end
end