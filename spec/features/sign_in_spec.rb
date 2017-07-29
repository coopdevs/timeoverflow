require 'spec_helper'

describe 'sign in' do
  let!(:user) do
    Fabricate(:user, email: 'user@timeoverflow.org', password: 'papapa22')
  end

  context 'with a valid password' do
    it 'signs the user in' do
      visit '/login'
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'papapa22'
      click_button I18n.t('application.login_form.button')

      expect(page).to have_content(I18n.t('application.navbar.sign_out'))
    end
  end

  context 'with an invalid password' do
    it 'shows an error' do
      visit '/login'
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'wrong_password'
      click_button I18n.t('application.login_form.button')

      expect(page).to have_content(I18n.t('devise.failure.invalid'))
    end
  end
end
