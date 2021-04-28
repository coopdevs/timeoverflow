class TagsController < ApplicationController
  before_action :authenticate_user!, :member_should_be_active

  def index
    model = params.key?(:member) ? Member : Post
    model_organization = model.by_organization(current_organization)
    @all_tags = model_organization.find_like_tag(params[:term])

    render json: @all_tags
  end

  def alpha_grouped_index
    redirect_to users_path && return unless current_organization

    post_type = params[:post_type] || "offer"
    @alpha_tags = case post_type
                  when "offer" then post_tags Offer
                  when "inquiry" then post_tags Inquiry
                  when "user" then Member.by_organization(current_organization).active
                  end.alphabetical_grouped_tags
    respond_to do |format|
      format.html
      format.js do
        render partial: "grouped_index", locals: { alpha_tags: @alpha_tags, post_type: post_type }
      end
    end
  end

  private

  def post_tags(type)
    type.by_organization(current_organization).active.of_active_members
  end
end
