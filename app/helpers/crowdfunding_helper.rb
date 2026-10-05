# app/helpers/crowdfunding_helper.rb
module CrowdfundingHelper
  CROWDFUNDING_LOCALES = %w[es ca en].freeze

  WIDGET_PATHS = {
    "es" => "",
    "ca" => "/ca",
    "en" => "/en"
  }.freeze

  CAUSE_PATHS = {
    "es" => "/reto",
    "ca" => "/ca/repte",
    "en" => "/en/cause"
  }.freeze

  def crowdfunding_locale
    locale = I18n.locale.to_s
    CROWDFUNDING_LOCALES.include?(locale) ? locale : "en"
  end

  def migranodearena_widget_url
    "https://www.migranodearena.org#{WIDGET_PATHS[crowdfunding_locale]}/widget/timeoverflow-needs-your-support"
  end

  def migranodearena_cause_url
    "https://www.migranodearena.org#{CAUSE_PATHS[crowdfunding_locale]}/timeoverflow-necesita-tu-apoyo"
  end

  def crowdfunding_image
    "crowdfunding-2026_#{crowdfunding_locale}.jpg"
  end
end
