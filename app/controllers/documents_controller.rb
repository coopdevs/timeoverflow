class DocumentsController < InheritedResources::Base
  respond_to :html, :js

  def show
    @document = Document.new(title: 'Missing document', content: 'Available very soon') if Document.find_by_id(params[:id]).blank?
    show! do |format|
      format.html do
        if params[:modal]
          render "show+modal", layout: false
        end
      end
    end
  end
end
