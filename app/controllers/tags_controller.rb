class TagsController < ApplicationController
  respond_to :json, :html

  def index

    @all_tags = Post::find_like_tag(params[:term])
    respond_with @all_tags

  end

  def alpha_grouped_index

    @alpha_tags = Post::alphabetical_grouped_tags
    respond_with @alpha_tags
  end
end
