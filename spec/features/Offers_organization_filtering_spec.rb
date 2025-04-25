require 'spec_helper'

RSpec.feature 'Offers organization filtering' do
  let(:organization) { Fabricate(:organization) }
  let(:other_organization) { Fabricate(:organization) }
  let(:category) { Fabricate(:category) }

  let(:user) do
    u = Fabricate(:user, password: "12345test", password_confirmation: "12345test")
    u.terms_accepted_at = Time.current
    u.save!
    u
  end

  let!(:member) { Fabricate(:member, organization: organization, user: user) }
  let!(:other_member) { Fabricate(:member, organization: other_organization) }

  before do
    OrganizationAlliance.create!(
      source_organization: organization,
      target_organization: other_organization,
      status: "accepted"
    )

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

    sign_in_with(user.email, "12345test")
  end

  scenario 'User filters posts by allied organization' do
    visit offers_path

    expect(page).to have_content("Local offer")
    expect(page).to have_content("Allied offer")

    find('a.dropdown-toggle', text: Organization.model_name.human(count: :other)).click

    query_params = { org: other_organization.id }
    link_path = "#{offers_path}?#{query_params.to_query}"
    visit link_path

    expect(page).to have_content("Allied offer")
    expect(page).not_to have_content("Local offer")
  end
end
