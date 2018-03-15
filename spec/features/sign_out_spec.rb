require 'spec_helper'

feature 'sign out' do
  let!(:user) do
    Fabricate(:user, email: 'user@timeoverflow.org', password: 'papapa22')
  end

  it 'signs the user out' do
    sign_in_with(user.email, user.password)
    click_link I18n.t('application.navbar.sign_out')

    expect(current_path).to eq(root_path)
  end
end
