RSpec.feature 'sign in' do
  let(:user) do
    user = Fabricate(
      :user,
      email: 'user@timeoverflow.org',
      password: 'papapa22',
      terms_accepted_at: 1.day.from_now
    )

    user.add_to_organization(organization)

    user
  end

  let(:organization) { Fabricate(:organization) }

  context 'with a branded org id' do
    before do
      allow(Rails.application.config).to receive(:branded_organization_id).and_return(organization.id)
      sign_in_with(user.email, user.password)
    end

    it 'renders the logo' do
      expect(page).to have_css('.organization-brand-logo')
    end
  end

  context 'without a branded org id' do
    before do
      allow(Rails.application.config).to receive(:branded_organization_id).and_return(1234)
      sign_in_with(user.email, user.password)
    end

    it 'does not render the logo' do
      expect(page).to have_no_css('.organization-brand-logo')
    end
  end
end

RSpec.feature 'sign out' do
  let!(:user) do
    Fabricate(
      :user,
      email: 'user@timeoverflow.org',
      password: 'papapa22',
      terms_accepted_at: 1.day.from_now
    )
  end

  context 'without a user' do
    it 'does not render the logo' do
      sign_in_with(user.email, user.password)
      click_link user.email
      click_link I18n.t('application.navbar.sign_out')

      expect(page).to have_no_css('.organization-brand-logo')
    end
  end
end
