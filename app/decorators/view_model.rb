# View model base class
# ---------------------
#
# Create a subclass to expose some specific methods from a business layer model
# plus view helpers and route helpers. The business object is readable as
# `object`, the view helpers as `view` and the route helpers as `routes`.
#
# Examples
# --------
#
# class UserDecorator < ViewModel
#   def path_to_edit
#     routes.edit_user_path(object)
#   end
#
#   def email_link
#     view.mail_to(object.email)
#   end
# end
#
# How to use
# ----------
#
# The first argument to the initializer is an arbitrary object, and the second
# is expected to respond correctly to view helpers like `link_to` and similar.
#
# From controllers, one can pass `self.class.helpers`, and from tests it is
# enough to use ApplicationController.new.view_context.
# 
class ViewModel
  attr_reader :object, :view, :routes

  def initialize(object, view)
    @object = object
    @view = view
    @routes = Rails.application.routes.url_helpers
  end
end

