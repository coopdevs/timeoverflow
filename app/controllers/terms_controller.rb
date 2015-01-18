class TermsController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :check_for_terms_acceptance!

  def show
    @document = Document.terms_and_conditions
  end

  def accept
    current_user.touch :terms_accepted_at
    redirect_to root_path
  end
end
