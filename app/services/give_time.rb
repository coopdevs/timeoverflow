class GiveTime
  def initialize(controller)
    @controller = controller
    @scope = controller.scoped_users
    @params = controller.params
    @organization = controller.send :current_organization
    @user = controller.current_user
  end

  def call
    @source = find_transfer_source
  end       

  def user
    scope.find(params[:id])
  end

  # Transfer object used to populate the simple_form_for in give_time.html.erb
  def transfer
    Transfer.new(
      source: @source,
      destination: destination,
      post: @offer
    )
  end

  def sources
    find_transfer_sources_for_admin
  end

  def offer
    find_transfer_offer
  end

  private

  attr_reader :scope, :params, :organization, :controller

  def find_transfer_source
    user.members.find_by(organization: organization).account.id
  end

  def find_transfer_offer
    organization.offers.find(params[:offer]) if params[:offer].present?
  end

  def find_transfer_sources_for_admin
    return unless controller.send :admin?
    [organization.account] + organization.member_accounts.where("members.active is true")
  end

  # TODO: Tighlty coupld with Transfer#make_movements. You don't notice that
  # model depends on this until it fails
  def destination
    user.members.find_by(organization: organization).account.id
  end
end
