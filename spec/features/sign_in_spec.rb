require 'spec_helper'

RSpec.feature 'sign in' do
  let(:user) do
    Fabricate(:user, email: 'user@timeoverflow.org', password: 'papapa22')
  end

  context 'with a valid password' do
    it 'signs the user in' do
      Capybara.current_session.driver.browser.manage.delete_cookie('_timeoverflow_session')

      sign_in_with(user.email, user.password)

      expect(Capybara.current_session.driver.browser.manage.cookie_named('_timeoverflow_session')).to be_truthy
      expect(page).not_to have_selector('.alert-danger')
    end
  end

  context 'with an invalid password' do
    it 'shows an error' do
      sign_in_with(user.email, 'wrong_password')

      expect(page).to have_selector('.alert-danger')
    end
  end
end
