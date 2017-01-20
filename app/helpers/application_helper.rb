require "date"

module ApplicationHelper

  TEXT_SUCCESS = 'text-success'.freeze
  TEXT_DANGER = 'text-danger'.freeze

  # from gravatar
  def avatar_url(user, size = 32)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    gravatar_options = Hash[set: "set1",
                            gravatar: "hashed",
                            size: "#{size}x#{size}"]
    "https://www.gravatar.com/avatar/#{gravatar_id}.png?" +
      "#{Rack::Utils.build_query(gravatar_options)}&d=identicon"
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
    I18n.available_locales.each do |locale|
      concat content_tag(:li,
                         link_to(locale_menu_item(locale),
                                 switch_lang_path(locale: locale)),
                         class: ("disabled" if I18n.locale == locale))
    end
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

  # Use as <%= markdown content %> or <%= m content %>
  # Content can be nil, in that case
  # it will be the same as an empty string.
  def markdown(content)
    RDiscount.new(content || ''.freeze).to_html.html_safe
  end

  alias m markdown

  # Green or red CSS class depending on whether
  # positive or negative amount
  def green_red(amount)
    case amount <=> 0
    when -1 then TEXT_DANGER
    when 0 then nil
    when 1 then TEXT_SUCCESS
    end
  end

  private

  def locale_menu_item(locale)
    t("locales.#{locale}", locale: locale).tap do |s|
      s << " (#{t("locales.#{locale}")})" unless I18n.locale == locale
    end
  end

  def get_body_css_class(controller)
    classes = {
      'home' => 'landing-page',
      'sessions' => 'login-page',
      'pages' => 'pages',
      'unlocks' => 'unlocks-page',
      'passwords' => 'passwords-page',
      'confirmations' => 'confirmations-page'
    }

    "#{classes[controller]}"
  end
end
