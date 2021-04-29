class TagsController < ApplicationController
  before_action :authenticate_user!, :member_should_be_active

  def index
    model = params[:model].classify.constantize
    posts = model.by_organization(current_organization)
    @tags = posts.find_like_tag(params[:term])

    render json: @tags
  end

  def alpha_grouped_index
    redirect_to users_path && return unless current_organization

    post_type = params[:post_type] || "offer"
    @tags = case post_type
                  when "offer"
                    Offer.by_organization(current_organization).active.of_active_members
                  when "inquiry"
                    Inquiry.by_organization(current_organization).active.of_active_members
                  when "user"
                    Member.by_organization(current_organization).active
                  end.alphabetical_grouped_tags

    respond_to do |format|
      format.html
      format.js do
        render partial: "grouped_index", locals: { alpha_tags: @tags, post_type: post_type }
      end
    end
  end
end
