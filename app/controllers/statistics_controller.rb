class StatisticsController < ApplicationController
  before_filter :authenticate_user!
  before_action :load_members, except: [:statistics_type_swaps,
                                        :statistics_all_transfers]
  before_action :load_transfers, only: [:statistics_global_activity,
                                        :statistics_all_transfers]

  def statistics_global_activity
    @data = StatsCalculator.new.global_activity(@members, @transfers,
                                                params[:from], params[:to])
  end

  def statistics_inactive_users
    @members = @members.active.includes(:account).sort_by(&:days_without_swaps).
               reverse.map { |a| a unless a.days_without_swaps.zero? }.compact
  end

  def statistics_demographics
    @age_counts = StatsCalculator.new.age_counts(@members)
  end

  def statistics_last_login
    @members = @members.active.joins(:user).
               order("users.current_sign_in_at ASC NULLS FIRST")
  end

  def statistics_without_offers
    @members = @members.active
  end

  def statistics_type_swaps
    offers = current_organization.posts.
             where(type: "Offer").joins(:transfers, transfers: :movements).
             select("posts.tags, posts.category_id, SUM(movements.amount) as
                     sum_of_transfers, COUNT(transfers.id) as
                     count_of_transfers").
             where("movements.amount > 0").
             group("posts.tags, posts.category_id, posts.updated_at")

    @offers = StatsCalculator.new.count_offers_by_label(offers).
              to_a.each { |a| a.flatten!(1) }.
              sort_by(&:last).reverse
  end

  def statistics_all_transfers
    @transfers = @transfers.
                 includes(movements: { account: :accountable }).
                 order("transfers.created_at DESC").
                 uniq.
                 page(params[:page]).
                 per(20)
  end

  protected

  def load_members
    @members = current_organization.members
  end

  def load_transfers
    @transfers = current_organization.all_transfers.
                 includes(:movements).
                 uniq
  end
end
