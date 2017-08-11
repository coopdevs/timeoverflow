require 'spec_helper'

describe 'time transfer', js: true do
  let(:user) do
    Fabricate(:user, email: 'user@timeoverflow.org', password: 'papapa22')
  end
  let(:other_user) do
    Fabricate(:user, email: 'other_user@timeoverflow.org', password: 'papapa22')
  end
  let(:organization) { Fabricate(:organization) }

  before do
    # Create terms and conditions
    Document.create(label: "t&c") do |doc|
      doc.title = "Terms and Conditions"
      doc.content = "blah blah blah"
    end

    user.add_to_organization(organization)
    other_user.add_to_organization(organization)
  end

  it 'transfers time from one account to another' do
    offer = Fabricate(:offer, user: other_user, organization: organization)
    sign_in_with(user.email, 'papapa22')

    within members_list do
      click_link other_user.username
    end

    click_link offer.title
    click_link I18n.t('offers.show.give_time_for')

    within transfer_form do
      fill_in 'transfer_hours', with: 2

      # hack alert! there is no translation for this string. How we build the
      # copy then?
      click_button 'Crear Transferencia'
    end

    expect(page).to have_css('.transactions tr', count: 1, text: '2:00')
  end

  def members_list
    find('.users tbody')
  end

  def transfer_form
    find('#new_transfer')
  end
end
