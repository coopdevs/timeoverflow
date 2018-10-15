# Managems of offer-type posts
#
class OffersController < PostsController
  def model
    Offer
  end

  def dashboard
    initial_scope =
      if current_organization
        current_organization.offers.active.of_active_members
      else
        Offer.all.active.of_active_members
      end
    @offers = initial_scope
      .includes(:category)
      .group_by(&:category_id)
      .each_with_object({}) do |(category, list), offers|
        offers[list.first.category] = list[0..5]
      end
  end

  def show
    super

    member = @offer.user.members.find_by(organization: current_organization)
    @destination_account = member.account if member
  end
end
