class SessionsController < Devise::SessionsController
  skip_before_filter :check_for_terms_acceptance!


end

