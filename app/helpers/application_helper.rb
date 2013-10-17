module ApplicationHelper
  def current_theme
    current_organization.try(:theme).presence || 'css'
  end
end
