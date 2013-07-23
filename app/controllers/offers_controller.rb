class OffersController < ApplicationController

  helper ActsAsTaggableOn::TagsHelper

  before_filter :load_tag_cloud, only: [:index]
  before_filter :parse_parameters, only: [:index]

  def index
    @offers = current_organization.offers
    @offers = @offers.tagged_with(@tag_list) if @tag_list
    @offers = @offers.where(category_id: @category) if @category
    if params[:q].present?
      @offers = @offers.where(Post.arel_table[:title].matches("%#{params[:q]}%"))
    end
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
    redirect_to current_organization.offers.find(params[:id]).tap do |offer|
      offer.joined_users << current_user
    end
  end

  def leave
    redirect_to current_organization.offers.find(params[:id]).tap do |offer|
      offer.joined_users -= [current_user]
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
        joinable: true,
        permanent: true
      }
    end

    def parse_parameters
      @tag_list = ActsAsTaggableOn::TagList.from params[:tag] if params[:tag].present?
      @category = Category.find params[:cat] if params[:cat].present?
    end


    def load_tag_cloud
      @tag_cloud = current_organization.offers.all_tags
    end


end
