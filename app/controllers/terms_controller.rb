class TermsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :check_for_terms_acceptance!

  def show
    @document = Document.terms_and_conditions
  end

  def accept
    current_user.touch :terms_accepted_at
    redirect_to(current_user.organizations.empty? ? organizations_path : root_path)
  end
end
