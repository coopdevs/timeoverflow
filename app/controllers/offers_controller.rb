class OffersController < PostsController
  def model
    Offer
  end

  def show
    super

    if @offer.user
      member = @offer.user.members.find_by(organization: current_organization)
      @destination_account = member.account if member
    end
  end
end
