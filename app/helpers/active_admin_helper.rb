module ActiveAdminHelper
  def render_translations(attribute, joiner = " | ")
     attribute.map do |locale, translation|
      tag.strong("#{I18n.t("locales.#{locale}", locale: locale)}: ") +
      tag.span(translation)
    end.join(joiner).html_safe
  end
end
