require 'spec_helper'

feature "login" do
  scenario "valid credentials are provided" do
    visit("/")
    #click_button 'Login'

    #fill_in 'E-mail', 'admin@timeoverflow.org'
    #fill_in 'Password', '1234test'
    page.save_screenshot("wat.png")
  end
end

