class TagsController < ApplicationController
  respond_to :json, :html

  def index

    @all_tags = (Post::all_tags || [])
    respond_with @all_tags

  end
end
