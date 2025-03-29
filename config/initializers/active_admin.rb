ActiveAdmin.setup do |config|
  config.site_title = "TimeOverflow"
  config.site_title_link = "/"
  config.breadcrumb = false
  config.footer = "TimeOverflow Admin | www.timeoverflow.org"
  config.authentication_method = :authenticate_superuser!
  config.current_user_method = :current_user
  config.logout_link_path = :destroy_user_session_path
  config.logout_link_method = :delete
  config.comments = false
  config.namespace :admin do |admin|
    admin.build_menu :utility_navigation do |menu|
      menu.add id: :languages, label: -> { "Languages (#{I18n.t("locales.#{locale}")})" } do |lang|
        I18n.available_locales.each do |locale|
          lang.add label: I18n.t("locales.#{locale}", locale: locale), url: ->{ url_for(locale: locale) }
        end
      end
      admin.add_current_user_to_menu menu
      admin.add_logout_button_to_menu menu
    end
  end
end
