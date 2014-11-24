# Managems of offer-type posts
#
class OffersController < PostsController
  def dashboard
    initial_scope = if current_organization
      current_organization.offers
    else
      Offer.all
    end
    @offers = Category.all.sort_by { |a| a.name.downcase }.
              each_with_object({}) do |category, offers|
      list = initial_scope.merge(category.posts).limit(5)
      offers[category] = list if list.present?
    end
  end
end
