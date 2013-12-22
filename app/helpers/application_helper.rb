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

end
