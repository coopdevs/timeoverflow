class OffersController < ApplicationController

  def index
    @offers = current_organization.offers
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
  end

  def destroy
  end

end
