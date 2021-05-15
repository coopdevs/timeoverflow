class OffersController < PostsController
  def model
    Offer
  end

  def show
    super

    member = @offer.user.members.find_by(organization: @offer.organization)
    @destination_account = member.account if member
  end
end
