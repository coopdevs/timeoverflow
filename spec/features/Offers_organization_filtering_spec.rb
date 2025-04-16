require 'spec_helper'

RSpec.feature 'Offers organization filtering' do
  let(:organization) { Fabricate(:organization) }
  let(:other_organization) { Fabricate(:organization) }
  let(:category) { Fabricate(:category) }
  let(:member) { Fabricate(:member, organization: organization) }
  let(:other_member) { Fabricate(:member, organization: other_organization) }
  let(:user) { member.user }

  before do
    user.terms_accepted_at = Time.current
    user.save!

    # Create an accepted alliance
    OrganizationAlliance.create!(
      source_organization: organization,
      target_organization: other_organization,
      status: "accepted"
    )

    # Create posts in both organizations
    Fabricate(:offer,
             user: user,
             organization: organization,
             category: category,
             title: "Local offer",
             active: true)

    Fabricate(:offer,
             user: other_member.user,
             organization: other_organization,
             category: category,
             title: "Allied offer",
             active: true)

    # Log in as user
    sign_in_with(user.email, user.password)
  end

  scenario 'User filters posts by allied organization' do
    visit offers_path

    # Should see posts from both organizations by default
    expect(page).to have_content("Local offer")
    expect(page).to have_content("Allied offer")

    # Click on the organization dropdown toggle
    find('a.dropdown-toggle', text: Organization.model_name.human(count: :other)).click

    # Find the organization in the dropdown menu and click it directly by url
    query_params = { org: other_organization.id }
    link_path = "#{offers_path}?#{query_params.to_query}"
    visit link_path

    # Should see only posts from selected organization
    expect(page).to have_content("Allied offer")
    expect(page).not_to have_content("Local offer")
  end
end
