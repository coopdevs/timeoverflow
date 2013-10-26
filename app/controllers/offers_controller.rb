class OffersController < ApplicationController
  respond_to :html, :js

  # helper ActsAsTaggableOn::TagsHelper
  before_filter :parse_parameters, only: [:index]

  def index
    @offers = current_organization.offers.categorized(@category)
    @offers = @offers.fuzzy_search(params[:q]) if params[:q].present?
    @offers = @offers.page(params[:page]).per(5)
    respond_with @offers
  end

  def show
    @offer = current_organization.offers.find(params[:id])
  end

  def new
    @offer = current_user.offers.new offer_defaults
  end

  def create
    redirect_to current_user.offers.create(offer_defaults.merge offer_params).tap do |offer|
      current_user.join(offer) unless admin?
      flash[:notice] = "Created!"
    end
  end

  def update
    redirect_to current_user.offers.find(params[:id]).tap do |offer|
      offer.update! offer_params
      current_user.join(offer) unless admin?
      flash[:notice] = "Updated!"
    end
  end

  def edit
    offers = if admin?
      current_organization.offers
    else
      current_user.offers
    end
    @offer = offers.find(params[:id])
  end

  def destroy
  end

  def join
    user = if admin? and params[:for_user].present?
      User.find(params[:for_user])
    else
      current_user
    end
    offer = current_organization.offers.find(params[:id])
    offer.joined_users << user
    if request.xhr?
      render nothing: true, status: :created
    else
      redirect_to offer
    end
  end

  def leave
    user = if admin? and params[:for_user].present?
      User.find(params[:for_user])
    else
      current_user
    end
    offer = current_organization.offers.find(params[:id])
    offer.joined_users -= [current_user]
    if request.xhr?
      render nothing: true, status: :no_content
    else
      redirect_to offer
    end
  end

  private

    def offer_params
      params.require(:offer).permit(
        :description, :end_on, :global, :joinable, :permanent, :start_on, :title,
        :category_id, :tag_list
      )
    end

    def offer_defaults
      {
        joinable: false,
        permanent: true
      }
    end

    def parse_parameters
      @tag_list = ActsAsTaggableOn::TagList.from params[:tag]
      @category = Category.find params[:cat] if params[:cat].present?
      @user = User.find params[:for_user] if params[:for_user].present?
    end


    def load_tag_cloud
      @tag_cloud = current_organization.offers.all_tags
    end


end
