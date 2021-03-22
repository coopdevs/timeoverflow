class TagsController < ApplicationController
  def index
    posts = Post.by_organization(current_organization)
    @all_tags = posts.find_like_tag(params[:term])

    render json: @all_tags
  end

  def alpha_grouped_index
    redirect_to users_path && return unless current_organization

    post_type = params[:post_type] || "offer"
    @alpha_tags = case post_type
                  when "offer" then Offer
                  when "inquiry" then Inquiry
                  end.by_organization(current_organization).
                  active.of_active_members.
                  alphabetical_grouped_tags

    respond_to do |format|
      format.html
      format.js do
        render partial: "grouped_index", locals: { alpha_tags: @alpha_tags, post_type: post_type }
      end
    end
  end
end
