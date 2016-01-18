class DocumentsController < ApplicationController
  def show
    @document = find_document_or_missing
    respond_to do |format|
      format.html do
        if params[:modal]
          render "show+modal", layout: false
        end
      end
    end
  end

  private

  def find_document_or_missing
    Document.find params[:id]
  rescue ActiveRecord::NotFound
    Document.new(title: "Missing document", content: "Available very soon")
  end
end
