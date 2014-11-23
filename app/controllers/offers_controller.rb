class OffersController < PostsController
  #before_filter :has_organization, :only => 'dashboard'

  def dashboard

    @offers = Hash.new
    Category.all.sort_by{ |a| a.name.downcase }.each do |category|
      if current_organization
        offers_by_category = current_organization.offers.merge(category.posts).limit(5)
      else
        offers_by_category = Offer.all.merge(category.posts).limit(5)
      end
      @offers[category] = offers_by_category if offers_by_category.any?
    end
  end

  private

  #def has_organization
  #   redirect_to(offers_path) unless current_organization
  #end

end
