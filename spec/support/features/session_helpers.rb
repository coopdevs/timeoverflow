module Features
  module SessionHelpers
    def sign_in_with(email, password)
      visit '/login'
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      find('input[type=submit]').click
    end
  end
end
