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

  def sortable(column, title = nil)  
    title ||= column.humanize 
    sort, dir = params[:sort], params[:direction]
    css_class = (column == sort)? "current #{dir}" : nil
    direction = (column == sort && dir == "asc")? "desc" : "asc"  
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}  
  end  

end
