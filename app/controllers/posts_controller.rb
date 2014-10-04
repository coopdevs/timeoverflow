class PostsController < InheritedResources::Base
  respond_to :html, :js

  has_scope :by_category, as: :cat
  has_scope :fuzzy_search, as: :q

  before_action only: %i[update destroy] do
    authorize resource
  end


  protected

  def collection
    get_collection_ivar || begin
      c = end_of_association_chain
      set_collection_ivar(c.page(params[:page]).per(25))
    end
  end

  def begin_of_association_chain
    current_organization
  end

  def build_resource_params
    permitted_fields = %i[description end_on global joinable permanent start_on title category_id tag_list user_id publisher_id]
    [
      params.fetch(resource_instance_name, {}).permit(*permitted_fields).tap { |p|
        if current_user.manages?(current_organization)
          p.update publisher_id: current_user.id
          p.reverse_merge! user_id: current_user.id
        else
          p.update user_id: current_user.id
        end
      }
    ]
  end
end
