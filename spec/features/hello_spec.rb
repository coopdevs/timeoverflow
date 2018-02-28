require 'spec_helper'

feature "hello capybara" do
  scenario "works" do
    visit("/")
    expect(page).to have_xpath('/html/body/nav/div/div/div/div[2]/div/ul/li[1]')
  end
end
