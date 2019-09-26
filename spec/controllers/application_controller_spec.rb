require 'spec_helper'

RSpec.describe ApplicationController do
  describe '#switch_lang' do
    let(:original_locale) { I18n.locale }

    before do
      request.env["HTTP_REFERER"] = root_path
    end

    after do
      I18n.locale = original_locale
    end

    it 'switches locale to passed language via params' do
      new_locale = (I18n.available_locales - [original_locale]).sample

      expect do
        get :switch_lang, params: { locale: new_locale }
      end.to change(I18n, :locale).from(original_locale).to(new_locale)

      expect(response).to redirect_to(root_path)
    end
  end
end
