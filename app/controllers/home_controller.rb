class HomeController < ApplicationController
  def index
    redirect_to :users if current_user
  end
end
