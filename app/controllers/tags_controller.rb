class TagsController < ApplicationController
  respond_to :json, :html

  def index

    @all_tags = Post::find_like_tag(params[:term])
    respond_with @all_tags

  end
end
