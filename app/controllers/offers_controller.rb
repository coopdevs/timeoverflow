# Managems of offer-type posts
#
class OffersController < PostsController
  def model
    Offer
  end

  def dashboard
    initial_scope =
      if current_organization
        current_organization.offers.actives
      else
        Offer.all.actives
      end
    @offers = Category.all.sort_by { |a| a.name.downcase }.
              each_with_object({}) do |category, offers|
      list = initial_scope.merge(category.posts.actives).limit(5)
      offers[category] = list if list.present?
    end
  end
end
