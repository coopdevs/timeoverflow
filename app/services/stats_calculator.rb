class StatsCalculator
  AGE_GROUP_LABELS = {
    0..17 => " -17",
    18..24 => "18-24",
    25..34 => "25-34",
    35..44 => "35-44",
    45..54 => "45-54",
    55..64 => "55-64",
    65..100 => "65+",
  }

  def global_activity(members, transfers, from, to)
    @from = from
    @to = to
    { actives: members.active.count,
      global_swaps: transfers.count,
      global_hours: transfers.map(&:amount_to).inject(0.0, :+),
      dates: months_years,
      users_reg: users_registrated(members),
      swaps: swaps(transfers),
      hours: hours(transfers)
    }
  end

  def age_counts(members)
    members.each_with_object(Hash.new(0)) do |member, counts|
      age = age(member.user_date_of_birth)
      age_label = AGE_GROUP_LABELS.detect do |range, _|
        range.include? age
      end.try(:last) || I18n.t("statistics.statistics_demographics.unknown")
      counts[age_label] += 1
    end
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

  private

  def init_date
    return Date.today - 5.month unless @from.present?

    @from.to_date
  end

  def end_date
    return Date.today unless @to.present?

    @to.to_date
  end

  def months_years
    (init_date..end_date).map { |d| I18n.l(d, format: "%B %Y") }.uniq
  end

  def dates
    (init_date..end_date).map(&:beginning_of_month).uniq
  end

  def users_registrated(members)
    dates.map { |d| members.by_month(d).count }
  end

  def swaps(transfers)
    dates.map { |d| transfers.by_month(d).count }
  end

  def hours(transfers)
    dates.map do |d|
      transfers.by_month(d).
        map(&:amount_to).
        inject(0.0, :+) / 3600
    end
  end

  def age(date_of_birth)
    return unless date_of_birth
    age_in_days = Date.today - date_of_birth
    (age_in_days / 365.26).to_i
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
                 [I18n.t("statistics.statistics_type_swaps.without_tags")]

    category_label = offer.category.try(:name) ||
                     I18n.t("statistics.statistics_type_swaps.without_category")

    [category_label].product(tag_labels)
  end
end
