class CategoriesController < ApplicationController
  respond_to :json

  load_and_authorize_resource

  def index
    respond_with @categories
  end

  def show
    respond_with @category
  end

  def create
    if @category.save
      render json: @category, status: :created, location: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def update
    if @category.update_attributes params[:category]
      respond_with @category
    else
      respond_with @category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    head :no_content
  end
end
