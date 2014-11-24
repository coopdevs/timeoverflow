# Managems of offer-type posts
#
class OffersController < PostsController

  before_action :ensure_organization, only: :dashboard

  def dashboard
    @offers = Category.all.sort_by { |a| a.name.downcase }.
              each_with_object({}) do |category, offers|
      list = current_organization.offers.merge(category.posts).limit(5)
      offers[category] = list if list.present?
    end
  end

  private

  def ensure_organization
    redirect_to(offers_path) unless current_organization
  end
end
