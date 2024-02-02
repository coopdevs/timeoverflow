class PagesController < ApplicationController
  def show
    render template: "pages/#{params[:page]}"
  rescue ActionView::MissingTemplate
    render "errors/not_found", status: :not_found
  end
end
