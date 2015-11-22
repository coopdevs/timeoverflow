# Taken from http://blog.dynamic50.com/2009/04/03/integration-testing-with-cucumber-and-pickle/

# Given(\/^#{capture_model} (?:has|have) registered$\/) do |name|
#    Given "#{name} exists"
#  end
#
#  Given(/^#{capture_model} (?:has|have) registered with "(\S+)", "(.*)"$/) do |name, email, password|
#    Given "#{name} exists with email: \"#{email}\", password: \"#{password}\", password_confirmation: \"#{password}\""
#  end
#
#  Given(/^#{capture_model} (?:is|am) activated( with "\S+", ".*")?$/) do |name, credentials|
#    Given "#{name} has registered#{credentials}"
#    created_model(name).confirm_email!
#  end

When "I go to the new session page" do
  visit new_user_session_path
end

When(/^I login with "(\S+)", "(.*)"$/) do |email, password|
  step "I go to the new session page"
  fill_in 'user_email', :with => email
  fill_in 'user_password', :with => password
  find(:input, '[name=commit]').click
end

Given "I am logged in" do
  @me ||= Fabricate(:member)
  step "I login with \"#{@me.user.email}\", \"#{@me.user.password}\""
  @current_organization = @me.organization
end

Given "I am an administrator" do
  @me = Fabricate(:admin)
end
