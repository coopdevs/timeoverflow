class CategoriesController < ApplicationController
  respond_to :json, :html

  load_and_authorize_resource

  def index

  end

  def root
    @categories = @categories.roots
    render 'index'
  end

  def global
    @categories = @categories.where organization_id: nil
    render 'index'
  end

  def local
    @categories = if superadmin?
      @categories.where "organization_id IS NOT NULL"
    else
      @categories.where organization_id: current_organization
    end
    render 'index'
  end

  def show
    # respond_with @category
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
      respond_with @category, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    head :no_content
  end

end
