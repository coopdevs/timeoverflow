When(/^I load a user's profile page$/) do
  @user = Fabricate(:member, organization: @current_organization).user
  visit user_path(@user)
  # pending # express the regexp above with the code you wish you had
end

Then(/^I see his avatar$/) do
  css = ".avatar-image"
  assert_selector ".avatar-image"

  # pending # express the regexp above with the code you wish you had
end

Given(/^I load my profile edit form$/) do
  step "I load the user edit page for #{@me.user.username}"
end

Given(/^I load the user edit page for (.+)$/) do |name|
  visit edit_user_path(User.find_by(username: name))
end

When(/^I upload a new avatar$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I see my avatar changed$/) do
  pending # express the regexp above with the code you wish you had
end


Given(/^I load a user's profile edit form$/) do
  @user = Fabricate(:member, organization: @current_organization).user
  step "I load the user edit page for #{@user.username}"
end

Then(/^I see the user's avatar changed$/) do
  pending # express the regexp above with the code you wish you had
end


Given(/^a terms and conditions document exists$/) do
  Document.platform_tnc_documents.first_or_create!
end
