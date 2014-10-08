class TagsController < ApplicationController
  respond_to :json, :html

  def index

    #@all_tags = (Post::all_tags.where("tag like ?","%#{params[:term]}%") || [])
    @all_tags = Post::tagged_like(params[:term])
    respond_with @all_tags

  end
end
