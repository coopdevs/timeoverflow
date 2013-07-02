class OffersController < ApplicationController

  helper ActsAsTaggableOn::TagsHelper

  def index
    @offers = current_organization.offers
    if params[:tag].present?
      @offers = @offers.tagged_with(params[:tag].split(",").map(&:strip))
    end
    if params[:cat].present?
      @offers = @offers.where(category_id: params[:cat])
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
    @offer = current_user.offers.create(params[:offer])
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

end
