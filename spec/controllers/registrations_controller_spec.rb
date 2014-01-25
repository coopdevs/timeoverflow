require 'spec_helper'

describe Devise::SessionsController do
  render_views

  it 'should do something' do
    get :sign_in

    Expect(response.body).not_to match "translation-missing"
  end
end