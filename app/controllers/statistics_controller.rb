class StatisticsController < ApplicationController
  AGE_GROUP_LABELS = {
    0..17 => " -17",
    18..24 => "18-24",
    25..34 => "25-34",
    35..44 => "35-44",
    45..54 => "45-54",
    55..64 => "55-64",
    65..100 => "65+",
  }

  before_filter :authenticate_user!

  def statistics_global_activity
    members = current_organization.members
    transfers = current_organization.all_transfers.
                includes(movements: { account: :accountable }).
                uniq

    # totals
    global_activity_totals(members, transfers)

    # periods show, by default 6 months
    init_date = params[:ini].presence.try(:to_date) ||
                DateTime.now.to_date - 5.month
    end_date = params[:fin].presence.try(:to_date) ||
               DateTime.now.to_date

    # name of months to table ["January", "February",...]
    @months_names = []
    # and data to table
    @user_reg_months = []
    @num_swaps_months = []
    @hours_swaps_months = []

    # total months to display
    num_months = calculate_number_of_months(init_date, end_date)
    date = init_date

    num_months.times do
      totals_by_month(members, transfers, date)

      date = date.next_month
    end
  end

  def statistics_inactive_users
    @members = current_organization.members.active
  end

  def statistics_demographics
    @members = current_organization.members
    @age_counts = age_counts
  end

  def statistics_last_login
    @members = current_organization.members.active.joins(:user).
               order("users.current_sign_in_at ASC NULLS FIRST")
  end

  def statistics_without_offers
    @members = current_organization.members.active
  end

  def statistics_type_swaps
    offers = current_organization.posts.
             where(type: "Offer").joins(:transfers, transfers: :movements).
             select("posts.tags, posts.category_id, SUM(movements.amount) as
                     sum_of_transfers, COUNT(transfers.id) as
                     count_of_transfers").
             where("movements.amount > 0").
             group("posts.tags, posts.category_id, posts.updated_at")

    @offers = count_offers_by_label(offers).to_a.each { |a| a.flatten!(1) }.
              sort_by(&:last).reverse
  end

  def statistics_all_transfers
    @transfers = current_organization.all_transfers.
                 includes(movements: { account: :accountable }).
                 order("transfers.created_at DESC").
                 uniq.
                 page(params[:page]).
                 per(20)
  end

  protected

  def global_activity_totals(members, transfers)
    @active_members = members.active
    @num_swaps = transfers.count
    @total_hours = transfers.
                   map { |t| t.movements.first.amount.abs }.
                   inject(0.0, :+)
  end

  def calculate_number_of_months(init_date, end_date)
    (end_date.year * 12 + end_date.month) -
      (init_date.year * 12 + init_date.month) + 1
  end

  def totals_by_month(members, transfers, date)
    @months_names.push(l(date, format: "%B %Y"))
    @user_reg_months.push(members.by_month(date).count)

    transfers_by_month = transfers.
                         by_month(l(date, format: "%m-%Y"))

    @num_swaps_months.push(transfers_by_month.count)

    hours_by_month = transfers_by_month.
                     map { |t| t.movements.first.amount.abs }.
                     inject(0, :+) / 3600

    @hours_swaps_months.push(hours_by_month)
  end

  def age(date_of_birth)
    return unless date_of_birth
    age_in_days = Date.today - date_of_birth
    (age_in_days / 365.26).to_i
  end

  # returns a hash of
  #     {
  #       [ category_label, tag_label ] => [ sum, count, ratio ],
  #       ...
  #     }
  def count_offers_by_label(offers)
    # Cannot use Hash.new([0, 0]) because then
    #     counters[key][0] += n
    # will modify directly the "global default" instead of
    # first assigning a new array with the zeroed counters.
    counters = Hash.new { |h, k| h[k] = [0, 0] }
    offers.each do |offer|
      labels_for_offer(offer).each do |labels|
        # labels = [ category_label, tag_label ]
        counters[labels][0] += offer.sum_of_transfers
        counters[labels][1] += offer.count_of_transfers
      end
    end
    add_ratios!(counters)
    counters
  end

  def add_ratios!(counters)
    # add the ratio at the end of each value
    total_count = counters.values.map { |_, counts| counts }.sum
    counters.each do |_, v|
      v << v[1].to_f / total_count
    end
  end

  # returns an array of
  #     [category_name, tag_name]
  # one item per each tag. If the category or the tags are missing, they are
  # replaced with a fallback "Unknown" label.
  def labels_for_offer(offer)
    tag_labels = offer.tags.presence ||
                 [t("statistics.statistics_type_swaps.without_tags")]

    category_label = offer.category.try(:name) ||
                     t("statistics.statistics_type_swaps.without_category")

    [category_label].product(tag_labels)
  end

  def age_counts
    @members.each_with_object(Hash.new(0)) do |member, counts|
      age = age(member.user_date_of_birth)
      age_label = AGE_GROUP_LABELS.detect do |range, _|
        range.include? age
      end.try(:last) || t("statistics.statistics_demographics.unknown")
      counts[age_label] += 1
    end
  end
end
