class TagsController < ApplicationController
  respond_to :json, :html, :js

  def index

    @all_tags = Post::find_like_tag(params[:term])
    respond_with @all_tags

  end

  def alpha_grouped_index

    #params = tags_params(params)
    post_type = params[:post_type] || "offer"

    case post_type
    when "offer"
      @alpha_tags = Offer::alphabetical_grouped_tags
    when "inquiry"
      @alpha_tags = Inquiry::alphabetical_grouped_tags
    when "all"
      @alpha_tags = Post::alphabetical_grouped_tags
    end

    respond_with @alpha_tags
  end

  private
  def tags_params
    params[:tags].permit(*%w"post_type")
  end

end
