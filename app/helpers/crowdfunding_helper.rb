module CrowdfundingHelper
  MIGRANODEARENA_PATHS = {
    "es" => "",
    "ca" => "/ca",
    "en" => "/en"
  }.freeze

  def migranodearena_widget_url
    prefix = MIGRANODEARENA_PATHS.fetch(I18n.locale.to_s, "/en")
    "https://www.migranodearena.org#{prefix}/widget/timeoverflow-needs-your-support"
  end
end
