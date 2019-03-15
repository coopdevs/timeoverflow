class HomeController < ApplicationController
  def index
    redirect_to :members if current_user
  end
end
