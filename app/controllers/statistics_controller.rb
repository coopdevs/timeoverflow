class StatisticsController < ApplicationController
  before_action :authenticate_user!

  def global_activity
    members = current_organization.members
    @active_members = members.active

    @total_hours = num_movements = 0
    members.each do |m|
      num_movements += m.account.movements.count
      @total_hours += m.account.movements.map do
        |a| (a.amount > 0) ? a.amount : 0
      end.inject(0, :+)
    end
    @total_hours += current_organization.account.movements.
                    map { |a| (a.amount > 0) ? a.amount : 0 }.inject(0, :+)

    @num_swaps = (num_movements + current_organization.account.movements.count) / 2

    from = params[:from].presence.try(:to_date) || DateTime.now.to_date - 5.month
    to = params[:to].presence.try(:to_date) || DateTime.now.to_date
    num_months = (to.year * 12 + to.month) - (from.year * 12 + from.month) + 1
    date = from

    @months_names = []
    @user_reg_months = []
    @num_swaps_months = []
    @hours_swaps_months = []

    num_months.times do
      @months_names << l(date, format: "%B %Y")
      @user_reg_months << members.by_month(date).count

      swaps_members = members.map { |a| a.account.movements.by_month(date) }
      swaps_organization = current_organization.account.movements.by_month(date)
      sum_swaps = (swaps_members.flatten.count + swaps_organization.count) / 2
      @num_swaps_months << sum_swaps

      sum_hours = 0
      swaps_members.flatten.each do |s|
        sum_hours += (s.amount > 0) ? s.amount : 0
      end
      sum_hours += swaps_organization.map do
        |a| (a.amount > 0) ? a.amount : 0
      end.inject(0, :+)
      sum_hours = sum_hours / 3600.0 if sum_hours > 0
      @hours_swaps_months << sum_hours

      date = date.next_month
    end
  end

  def inactive_users
    @members = current_organization.members.active
  end

  def demographics
    members = current_organization.members
    @age_counts = age_counts(members)
    @gender_counts = gender_counts(members)
  end

  def last_login
    @members = current_organization.members.active.joins(:user).
               order("users.current_sign_in_at ASC NULLS FIRST")
  end

  def without_offers
    @members = current_organization.members.active
  end

  def type_swaps
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

  def all_transfers
    @transfers = current_organization.all_transfers.
                 includes(movements: {account: :accountable}).
                 order("transfers.created_at DESC").
                 distinct.
                 page(params[:page]).
                 per(20)
  end

  protected

  def count_offers_by_label(offers)
    # Cannot use Hash.new([0, 0]) because then counters[key][0] += n
    # will modify directly the "global default" instead of
    # first assigning a new array with the zeroed counters.
    counters = Hash.new { |h, k| h[k] = [0, 0] }

    offers.each do |offer|
      labels_for_offer(offer).each do |labels|
        counters[labels][0] += offer.sum_of_transfers
        counters[labels][1] += offer.count_of_transfers
      end
    end
    add_ratios(counters)

    counters
  end

  def add_ratios(counters)
    total_count = counters.values.map { |_, counts| counts }.sum

    counters.each do |_, v|
      v << v[1].to_f / total_count
    end
  end

  def labels_for_offer(offer)
    tag_labels = offer.tags.presence ||
                 [t("statistics.type_swaps.without_tags")]

    category_label = offer.category.try(:name) ||
                     t("statistics.type_swaps.without_category")

    [category_label].product(tag_labels)
  end

  def age_counts(members)
    members.each_with_object(Hash.new(0)) do |member, counts|
      age = compute_age(member.user_date_of_birth)

      age_label = age_group_labels.detect do |range, _|
        range.include? age
      end.try(:last) || t("statistics.demographics.unknown")

      counts[age_label] += 1
    end
  end

  def compute_age(date_of_birth)
    return unless date_of_birth

    age_in_days = Date.today - date_of_birth
    (age_in_days / 365.26).to_i
  end

  def age_group_labels
    {
      0..17   => "-17",
      18..24  => "18-24",
      25..34  => "25-34",
      35..44  => "35-44",
      45..54  => "45-54",
      55..64  => "55-64",
      65..100 => "65+",
    }
  end

  def gender_counts(members)
    members.each_with_object(Hash.new(0)) do |member, counts|
      gender = member.user_gender
      gender_label = if gender.present?
        t("simple_form.options.user.gender.#{gender}")
      else
        t("statistics.demographics.unknown")
      end
      counts[gender_label] += 1
    end
  end
end
