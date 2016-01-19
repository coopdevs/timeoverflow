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
    @members = current_organization.members
    @active_members = @members.active
    @total_hours = num_movements = 0
    @members.each do |m|
      num_movements += m.account.movements.count
      @total_hours += m.account.movements.map do
        |a| (a.amount > 0) ? a.amount : 0
      end.inject(0, :+)
    end
    # cada intercambio implica dos movimientos
    @num_swaps = (num_movements +
                  current_organization.account.movements.count) / 2
    # intercambios con el banco
    @total_hours += current_organization.account.movements.
                    map { |a| (a.amount > 0) ? a.amount : 0 }.inject(0, :+)
    # periodo a mostrar actividades globales, por defecto 6 meses
    ini = params[:ini].presence.try(:to_date) || DateTime.now.to_date - 5.month
    fin = params[:fin].presence.try(:to_date) || DateTime.now.to_date
    if ini.present?
      # calculo numero de meses
      num_months = (fin.year * 12 + fin.month) - (ini.year * 12 + ini.month) + 1
      date = ini
      # vector para los meses de la gráfica ["Enero", "Febrero",...]
      @months_names = []
      # y vectores con los datos para la gráfica
      @user_reg_months = []
      @num_swaps_months = []
      @hours_swaps_months = []
      # valores por cada mes
      num_months.times do
        @months_names.push(l(date, format: "%B %Y"))
        @user_reg_months.push(@members.by_month(date).count)
        # movimientos de los miembros en dicho mes
        swaps_members = @members.map { |a| a.account.movements.by_month(date) }
        # movimimentos del banco
        swaps_organization = current_organization.account.
                             movements.by_month(date)
        # numero de movimientos totales
        sum_swaps = (swaps_members.flatten.count + swaps_organization.count) / 2
        @num_swaps_months.push(sum_swaps)
        # horas intercambiadas
        sum_hours = 0
        swaps_members.flatten.each do |s|
          sum_hours += (s.amount > 0) ? s.amount : 0
        end
        sum_hours += swaps_organization.map do
          |a| (a.amount > 0) ? a.amount : 0
        end.inject(0, :+)
        sum_hours = sum_hours / 3600.0 if sum_hours > 0
        @hours_swaps_months.push(sum_hours)
        date = date.next_month
      end
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
                 includes(movements: {account: :accountable}).
                 order("transfers.created_at DESC").
                 uniq.
                 page(params[:page]).
                 per(20)
  end

  protected

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
