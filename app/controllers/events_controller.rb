class EventsController <  ApplicationController
  def index
    @events = current_organization.events
  end
end
