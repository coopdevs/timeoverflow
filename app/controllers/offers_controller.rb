# Managems of offer-type posts
#
class OffersController < PostsController
  def model
    Offer
  end

  def show
    super

    member = @offer.user.members.find_by(organization: current_organization)
    @destination_account = member.account if member
  end
end
