module ApplicationHelper
  def theme_stylesheet_link_tag
    theme = current_organization.try(:theme)
    url = if Organization::BOOTSWATCH_THEMES.include? theme
      "//netdna.bootstrapcdn.com/bootswatch/3.0.0/#{theme}/bootstrap.min.css"
    else
      "//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css"
    end
    stylesheet_link_tag url
  end
end
