require 'date'

module ApplicationHelper

  # froom http://railscasts.com/episodes/244-gravatar?language=en&view=asciicast
  def avatar_url(user, size=32)
    gravatar_id = gravatar_digest user
    gravatar_options = Hash[s: size, d: 'identicon']
    "http://gravatar.com/avatar/#{gravatar_id}.png?#{Rack::Utils.build_query(gravatar_options)}"
  end

  def gravatar_link user
    "http://gravatar.com/#{gravatar_digest(user)}"
  end
  
  def gravatar_digest user
    email = user.gravatar_email.blank? ? user.email : user.gravatar_email
    gravatar_id = Digest::MD5::hexdigest email.downcase
    gravatar_id
  end


  def theme_stylesheet_link_tag
    theme = current_organization.try(:theme)
    url = if Organization::BOOTSWATCH_THEMES.include? theme
      "//netdna.bootstrapcdn.com/bootswatch/3.1.0/#{theme}/bootstrap.min.css"
    else
      "//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css"
    end
    stylesheet_link_tag url
  end

  def mdash
    raw "&mdash;"
  end

  def seconds_to_hm(seconds)
    sign = seconds <=> 0
    if sign.try :nonzero?
      minutes, seconds = seconds.abs.divmod(60)
      hours, minutes = minutes.divmod(60)
      raw format("%s%d:%02d", ("-" if sign < 0), hours, minutes)
    else
      mdash
    end
  end

  def tnc_path
    document_path(Document.terms_and_conditions || 0, modal: true)
  end

  def age date_of_birth
    now = DateTime.now
    age = now.year - date_of_birth.year
    age -= 1 if((now.month < date_of_birth.month) || (now.month == date_of_birth.month && now.day < date_of_birth.day))
    age
  end

end
