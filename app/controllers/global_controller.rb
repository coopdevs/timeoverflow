class GlobalController < ApplicationController

  def switch_lang
    set_locale

    if current_user and current_organization
      redirect_to offers_path
    else
      go_home
    end
  end

  def go_home
    l = session[:locale]

    case l
    when 'es'
      url='home'
    else
      url='home_'+l
    end
    redirect_to page_path(url)
  end


end
