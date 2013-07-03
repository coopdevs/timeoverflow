class OffersController < ApplicationController

  helper ActsAsTaggableOn::TagsHelper

  before_filter :load_tag_cloud, only: [:index]

  def index
    @offers = current_organization.offers
    @tag_list = ActsAsTaggableOn::TagList.from(params[:tag])
    if @tag_list.present?
      @offers = @offers.tagged_with(@tag_list)
    end
    if params[:cat].present?
      @offers = @offers.where(category_id: params[:cat])
      @category = Category.find params[:cat]
    end
    if params[:q].present?
      @offers = @offers.where(Post.arel_table[:title].matches("%#{params[:q]}%"))
    end
  end

  def show
    @offer = current_organization.offers.find(params[:id])
  end

  def new
    @offer = current_user.offers.new
  end

  def create
    @offer = current_user.offers.create(offer_params)
    unless admin?
      current_user.join(@offer)
    end
    redirect_to :offers, notice: "Created!"
  end

  def update
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
    @offer = current_organization.offers.find(params[:id])
    @offer.joined_users << current_user
    redirect_to @offer
  end

  def leave
    @offer = current_organization.offers.find(params[:id])
    @offer.joined_users -= [current_user]
    redirect_to @offer
  end

  private

    def offer_params
      params.require(:offer).permit(
        :description, :end_on, :global, :joinable, :permanent, :permanent, :start_on, :title,
        :category_id, :tag_list
      )

    end

    def load_tag_cloud
      @tag_cloud = current_organization.offers.all_tags
    end


end
