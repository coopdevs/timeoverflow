class DocumentsController < InheritedResources::Base
  respond_to :html, :js

  def show
    show! do |format|
      format.html do
        if params[:modal]
          render "show+modal", layout: false
        end
      end
    end
  end
end
