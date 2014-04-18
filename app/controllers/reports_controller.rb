class ReportsController < ApplicationController
  before_filter :authenticate_user!

  layout "report", except: :statistics

  def user_list
    @members = current_organization.members.includes(:user).order("members.member_uid")
  end

  def post_list
    @post_type = (params[:type] || "offer").capitalize.constantize
    @posts = current_organization.posts.where(type: @post_type).group_by(&:category).to_a.sort_by {|c, p| c.try(:name) || ""}
  end

  def statistics
    @members = current_organization.members
    @total_hours = num_movements = 0
    @members.each do |m|
      num_movements += m.account.movements.count
      @total_hours += m.account.movements.map{ |a| (a.amount > 0)? a.amount : 0 }.inject(0,:+)
    end
    # cada intercambio implica dos movimientos
    @num_swaps = (num_movements + current_organization.account.movements.count)/2
  end
end

