require 'spec_helper'

describe 'sign out' do
  let!(:user) do
    Fabricate(:user, email: 'user@timeoverflow.org', password: 'papapa22')
  end

  it 'signs the user out' do
    visit '/login'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'papapa22'
    click_button I18n.t('application.login_form.button')

    click_link I18n.t('application.navbar.sign_out')

    expect(current_path).to eq(root_path)
  end
end
