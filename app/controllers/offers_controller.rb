class OffersController < InheritedResources::Base
  respond_to :html, :js

  has_scope :by_category, as: :cat
  has_scope :fuzzy_search, as: :q

  protected

  def collection
    @offers ||= end_of_association_chain.page(params[:page]).per(5)
  end

  def begin_of_association_chain
    current_organization
  end

  def permitted_params
    params.permit(offer: [
      :description, :end_on, :global, :joinable, :permanent, :start_on, :title,
      :category_id, :tag_list
    ])
  end

end
