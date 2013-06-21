class CategoriesController < ApplicationController
  respond_to :json, :html

  load_and_authorize_resource

  def index
  end

  def show
    # respond_with @category
  end

  def create
    if @category.save
      redirect_to @category
    else
      render :new
    end
  end

  def update
    if @category.update_attributes params[:category]
      redirect_to @category
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to :index
  end

end
