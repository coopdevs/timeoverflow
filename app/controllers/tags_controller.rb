class TagsController < ApplicationController
  def index
    @posts = Post.by_organization(current_organization)
    @all_tags = @posts.find_like_tag(params[:term])

    render json: @all_tags
  end

  def alpha_grouped_index
    redirect_to users_path && return unless current_organization

    @alpha_tags = case params[:post_type] || "offer"
                  when "offer" then Offer
                  when "inquiry" then Inquiry
                  end.by_organization(current_organization).
                  active.of_active_members.
                  alphabetical_grouped_tags
  end

  def inquiries
    @alpha_tags = Inquiry.by_organization(current_organization).active.of_active_members.
                  alphabetical_grouped_tags

    render partial: "grouped_index", locals: { alpha_tags: @alpha_tags, post_type: "inquiries" }
  end

  def offers
    @alpha_tags = Offer.by_organization(current_organization).active.of_active_members.
                  alphabetical_grouped_tags

    render partial: "grouped_index", locals: { alpha_tags: @alpha_tags, post_type: "offers" }
  end
end
