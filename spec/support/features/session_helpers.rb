module Features
  module SessionHelpers
    def sign_in_with(email, password)
      visit '/login'
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      click_button
    end
  end
end
