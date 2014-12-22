class TagsController < ApplicationController
  respond_to :json, :html, :js

  def index
    @posts = Post.by_organization(current_organization)
    @all_tags = @posts.find_like_tag(params[:term])
    respond_with @all_tags
  end

  def alpha_grouped_index
    permitted = tags_params(params)
    @current_post_type = permitted[:post_type] || "offer"

    @offers_tagged = []
    @inquiries_tagged = []

    redirect_to users_path && return unless current_organization

    @alpha_tags = alpha_tags_from_post_type(@current_post_type)

    respond_with @alpha_tags
  end

  def alpha_grouped_destroy
    alpha_grouped_index
  end

  def alpha_grouped_rename
    alpha_grouped_index
  end

  def inquiries
    inquiries_load
    render partial: "grouped_index", locals: { alpha_tags: @alpha_tags }
  end

  def offers
    offers_load
    render partial: "grouped_index", locals: { alpha_tags: @alpha_tags }
  end

  def destroy_inquiries
    inquiries_load
    render partial: "grouped_admin_index", locals: { alpha_tags: @alpha_tags,
                                                     action: "/tags/destroy" }
  end

  def destroy_offers
    offers_load
    render partial: "grouped_admin_index", locals: { alpha_tags: @alpha_tags,
                                                     action: "/tags/destroy" }
  end

  def rename_inquiries
    inquiries_load
    render partial: "grouped_admin_index", locals: { alpha_tags: @alpha_tags,
                                                     action: "/tags/rename" }
  end

  def rename_offers
    offers_load
    render partial: "grouped_admin_index", locals: { alpha_tags: @alpha_tags,
                                                     action: "/tags/rename" }
  end

  def posts_with
    permitted = tags_params(params)
    tagname = permitted[:tagname] || ""

    @offers_tagged = Offer.active_tagged_with(current_organization, tagname)
    @inquiries_tagged = Inquiry.active_tagged_with(current_organization,
                                                   tagname)
    respond_with @offers_tagged, @inquiries_tagged
  end

  # POST
  # Renames selected tags using new provided name
  def rename
    permitted = reorganize_tags_params(params)

    @current_post_type = permitted[:current_post_type] || "offer"
    @alpha_tags = alpha_tags_from_post_type(@current_post_type)

    merge(@current_post_type, permitted[:new_name], selected_tags(permitted))

    redirect_to alpha_grouped_rename_tags_path(post_type: @current_post_type)
  end

  # POST
  # Destroys selected tags
  def destroy
    permitted = reorganize_tags_params(params)

    @current_post_type = permitted[:current_post_type] || "offer"
    @alpha_tags = alpha_tags_from_post_type(@current_post_type)

    delete(@current_post_type, selected_tags(permitted))

    redirect_to alpha_grouped_destroy_tags_path(post_type: @current_post_type)
  end

  private

  def tags_params(params)
    params.permit(:post_type, :tagname)
  end

  # params for merge_tags and delete_tags action
  def reorganize_tags_params(params)
    params.permit(:current_post_type,
                  :new_name,
                  :delete_button,
                  :merge_button,
                  tags: [])
  end

  def offers_load
    @current_post_type = "offer"
    @alpha_tags = Offer.active_alpha_tags(current_organization)
  end

  def inquiries_load
    @current_post_type = "inquiry"
    @alpha_tags = Inquiry.active_alpha_tags(current_organization)
  end

  def alpha_tags_from_post_type(post_type)
    case post_type
    when "offer" then Offer
    when "inquiry" then Inquiry
    when "all" then Post
    end.active_alpha_tags(current_organization)
  end

  def selected_tags(params)
    params[:tags] || []
  end

  def merge(post_type, new_name, selected_tags)
    case post_type
    when "offer" then Offer
    when "inquiry" then Inquiry
    when "all" then Post
    end.merge_tags(current_organization, new_name, selected_tags)
  end

  def delete(post_type, selected_tags)
    case post_type
    when "offer" then Offer
    when "inquiry" then Inquiry
    when "all" then Post
    end.delete_tags(current_organization, selected_tags)
  end
end
