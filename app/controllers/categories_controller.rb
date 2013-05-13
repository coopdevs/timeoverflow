class CategoriesController < ApplicationController
  respond_to :json, :html

  load_and_authorize_resource

  def index
    send params[:filter] if params[:filter]
  end

  def root
    @categories = @categories.roots
  end

  def global
    @categories = @categories.where organization_id: nil
  end

  def local
    @categories = if superadmin?
      @categories.where "organization_id IS NOT NULL"
    else
      @categories.where organization_id: current_organization
    end
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
