module ApplicationHelper

  # froom http://railscasts.com/episodes/244-gravatar?language=en&view=asciicast
  def avatar_url(user, size=32)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    gravatar_options = Hash[s: size, d: 'identicon']
    "http://gravatar.com/avatar/#{gravatar_id}.png?#{Rack::Utils.build_query(gravatar_options)}"
  end


  def theme_stylesheet_link_tag
    theme = current_organization.try(:theme)
    url = if Organization::BOOTSWATCH_THEMES.include? theme
      "//netdna.bootstrapcdn.com/bootswatch/3.0.3/#{theme}/bootstrap.min.css"
    else
      "//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css"
    end
    stylesheet_link_tag url
  end

  def mdash
    "&mdash;".html_safe
  end

  def seconds_to_hm(seconds)
    if !seconds.zero?
      sign = seconds / seconds.abs
      mm, ss = seconds.abs.divmod(60)
      hh, mm = mm.divmod(60)

      output = I18n.translate "transfers.computation.hour", count: hh unless hh.zero?

      if output
        output.concat(I18n.translate("transfers.computation.joiner")).concat(I18n.translate("transfers.computation.minute", count: mm)) unless mm.zero?
      else
        output = I18n.translate("transfers.computation.minute", count: mm) unless mm.zero?
      end

      sign > 0 ? output : "-".concat(output)
    end
  end

  def tnc_path
    document_path(Document.terms_and_conditions, modal: true)
  end

end
