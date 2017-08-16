require 'spec_helper'

describe 'sign in' do
  let(:user) do
    Fabricate(:user, email: 'user@timeoverflow.org', password: 'papapa22')
  end

  context 'with a valid password' do
    it 'signs the user in' do
      sign_in_with(user.email, 'papapa22')
      expect(page).to have_content(I18n.t('application.navbar.sign_out'))
    end
  end

  context 'with an invalid password' do
    it 'shows an error' do
      sign_in_with(user.email, 'wrong_password')
      expect(page).to have_content(I18n.t('devise.failure.invalid'))
    end
  end
end
