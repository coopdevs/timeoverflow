RSpec.feature 'sign out' do
  let!(:user) do
    Fabricate(
      :user,
      email: 'user@timeoverflow.org',
      password: 'papapa22',
      terms_accepted_at: 1.day.from_now
    )
  end

  it 'signs the user out' do
    sign_in_with(user.email, user.password)
    click_link user.email
    click_link I18n.t('application.navbar.sign_out')

    expect(current_path).to eq(root_path)
  end
end
