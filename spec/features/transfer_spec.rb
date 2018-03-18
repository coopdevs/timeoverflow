require 'spec_helper'

feature 'time transfer' do
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

  let(:other_user) do
    other_user = Fabricate(:user, email: 'other_user@timeoverflow.org', password: 'papapa22')

    other_user.add_to_organization(organization)
    other_user
  end

  let(:organization) { Fabricate(:organization) }

  it 'transfers time from one account to another' do
    offer = Fabricate(:offer, user: other_user, organization: organization)
    sign_in_with(user.email, user.password)
    navigate_to_member
    navigate_to_transfer_for(offer)
    submit_transfer_form_with(hours: 2)

    expect(page).to have_css('.transactions tr', count: 1, text: '2:00')
  end

  def submit_transfer_form_with(hours: nil, minutes: nil)
    within transfer_form do
      fill_in 'transfer_hours', with: hours
      fill_in 'transfer_minutes', with: minutes

      click_button 'Crear Transferencia'
    end
  end

  def navigate_to_transfer_for(offer)
    click_link offer.title
    click_link I18n.t('offers.show.give_time_for')
  end

  def navigate_to_member
    within members_list do
      click_link other_user.username
    end
  end

  def members_list
    find('.users tbody')
  end

  def transfer_form
    find('#new_transfer')
  end
end
