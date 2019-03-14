require 'spec_helper'

RSpec.feature 'create offer' do
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

  let!(:category) do
    Category.create(name: 'le category')
  end

  context 'create an offer' do
    it 'can be created' do
      sign_in_with(user.email, user.password)
      click_on I18n.t('activerecord.models.offer.other')
      click_on I18n.t('helpers.submit.create', model: I18n.t('activerecord.models.offer.one'))
      fill_in 'offer_title', with: 'Le title'
      fill_in 'offer_description', with: 'Lorem ipsum in the night'
      select category.name, from: 'offer_category_id'

      # TODO there are two i18n keys for getting "Crear oferta" copy ( one returns 'Crear oferta' and the other 'Crear Oferta' )
      click_on I18n.t('offers.new.submit', model: I18n.t('activerecord.models.offer.one'))
    end
  end
end

