class InquiriesController < ApplicationController

  def index
    @inquiries = current_organization.inquiries
  end

  def show
    @inquiry = current_organization.inquiries.find(params[:id])
  end

  def new
    @inquiry = current_user.inquiries.new
  end

  def create
    @inquiry = current_user.inquiries.create(params[:inquiry])
    unless admin?
      current_user.join(@inquiry)
    end
    redirect_to :inquiries, notice: "Created!"
  end

  def update
  end

  def edit
    inquiries = if admin?
      current_organization.inquiries
    else
      current_user.inquiries
    end
    @inquiry = inquiries.find(params[:id])
  end

  def destroy
  end

  def join
    @inquiry = current_organization.inquiries.find(params[:id])
    @inquiry.joined_users << current_user
    redirect_to @inquiry
  end

  def leave
    @inquiry = current_organization.inquiries.find(params[:id])
    @inquiry.joined_users -= [current_user]
    redirect_to @inquiry
  end

end
