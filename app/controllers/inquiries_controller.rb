class InquiriesController < ApplicationController
  respond_to :html, :js
  before_filter :parse_parameters, only: [:index]


  def index
    @inquiries = current_organization.inquiries.
      categorized(@category).
      page(params[:page]).per(5)
    respond_with @inquiries
  end

  def show
    @inquiry = current_organization.inquiries.find(params[:id])
  end

  def new
    @inquiry = current_user.inquiries.new
  end

  def create
    @inquiry = current_user.inquiries.create(inquiry_params)
    unless admin?
      current_user.join(@inquiry)
    end
    redirect_to :inquiries, notice: "Created!"
  end

  def update
    @inquiry = current_user.inquiries.find(params[:id])
    @inquiry.update_attributes(inquiry_params)
    redirect_to @inquiry, notice: "Updated!"
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


  private

  def inquiry_params
    params.require(:inquiry).permit(
      :description, :end_on, :global, :joinable, :permanent, :start_on, :title,
      :category_id, :tag_list
    )
  end

  def inquiry_defaults
    {
      joinable: false,
      permanent: true
    }
  end

  def parse_parameters
    @category = Category.find params[:cat] if params[:cat].present?
  end

end
