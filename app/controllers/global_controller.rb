class GlobalController < ApplicationController
  def switch_lang
    if current_user && current_organization
      redirect_to offers_path
    else
      go_home
    end
  end

  def go_home
    url = case session[:locale].to_s
          when "es"
            "home"
          else
            "home_#{session[:locale]}"
          end
    redirect_to page_path(url)
  end
end
