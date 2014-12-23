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

  def inquiries
    @current_post_type = "inquiry"
    @alpha_tags = Inquiry.active_alpha_tags(current_organization)
    render partial: "grouped_index", locals: { alpha_tags: @alpha_tags }
  end

  def offers
    @current_post_type = "offer"
    @alpha_tags = Offer.active_alpha_tags(current_organization)
    render partial: "grouped_index", locals: { alpha_tags: @alpha_tags }
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
  # Allows to reorganize tags by allowing actor to merge or delete tags
  def reorganize
    # permitted = tags_params(params)
    # tagname = permitted[:tagname] || ""
    @current_post_type = params[:current_post_type]
    @alpha_tags = alpha_tags_from_post_type(@current_post_type)

    case params[:button]
    when "merge" then merge(@current_post_type,
                            params[:new_name],
                            selected_tags(params))
    when "delete" then delete(@current_post_type, selected_tags(params))
    end

    render alpha_grouped_index_tags_path, post_type: @current_post_type
  end

  private

  def tags_params(params)
    params.permit(:post_type, :tagname)
  end

  def alpha_tags_from_post_type(post_type)
    case post_type
    when "offer" then Offer
    when "inquiry" then Inquiry
    when "all" then Post
    end.active_alpha_tags(current_organization)
  end

  def selected_tags(params)
    st = []
    params.each do |k, p|
      st << k.match(/tag_([^\/.]*)$/)[1] if /^tag_.+$/ =~ k && p == "1"
    end
    st
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

  # TODO control params for reorganize action including tag_* params
  # def reorganize_tags_params(params)
  #  params.permit(:)
  # end
end
