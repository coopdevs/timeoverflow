require "date"

module ApplicationHelper
  # froom http://railscasts.com/episodes/244-gravatar?language=en&view=asciicast
  def avatar_url(user, size = 32)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    gravatar_options = Hash[s: size, d: "identicon"]
    "http://gravatar.com/avatar/#{gravatar_id}.png?" +
      "#{Rack::Utils.build_query(gravatar_options)}"
  end

  def theme_stylesheet_link_tag
    theme = current_organization.try(:theme)
    main_url = "//netdna.bootstrapcdn.com/"
    bs_version = "3.1.0"
    bs_css_file = "bootstrap.min.css"
    url = if Organization::BOOTSWATCH_THEMES.include? theme
            "#{main_url}/bootswatch/#{bs_version}/#{theme}/#{bs_css_file}"
          else
            "#{main_url}/bootstrap/#{bs_version}/css/#{bs_css_file}"
          end
    stylesheet_link_tag url
  end

  def mdash
    raw "&mdash;"
  end

  def seconds_to_hm(seconds)
    sign = seconds <=> 0
    if sign.try :nonzero?
      minutes, _seconds = seconds.abs.divmod(60)
      hours, minutes = minutes.divmod(60)
      raw format("%s%d:%02d", ("-" if sign < 0), hours, minutes)
    else
      mdash
    end
  end

  def tnc_path
    document_path(Document.terms_and_conditions || 0, modal: true)
  end

  def languages_list
    locales = I18n.available_locales

    locales.map do |locale|
      content_tag(:li, class: I18n.locale == locale ? :disabled : "") do
        locale_key = "locales.#{locale}"
        link_name = t(locale_key, locale: locale)
        link_name << " (#{t(locale_key)})" if I18n.locale != locale

        link_to link_name, switch_lang_path(locale: locale)
      end
    end.join.html_safe
  end

  def show_error_messages!(resource)
    return "" if resource.errors.empty?

    messages = resource.errors.
               full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block"> <button type="button"
      class="close" data-dismiss="alert">x</button>
      #{messages}
    </div>
    HTML

    html.html_safe
  end
end
