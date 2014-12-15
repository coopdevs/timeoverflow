class StatisticsController < ApplicationController
  before_filter :authenticate_user!

  def statistics_global_activity
    @members = current_organization.members
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
    @members = current_organization.members
  end

  def statistics_demographics
    @members = current_organization.members

    @age_groups = @members.group_by do |member|
      case (age(member.user.date_of_birth.presence) rescue nil)
      when 0..17 then " -17"
      when 18..24 then "18-24"
      when 25..34 then "25-34"
      when 35..44 then "35-44"
      when 45..54 then "45-54"
      when 55..64 then "55-64"
      when 65..100 then "65+"
      else t("statistics.statistics_demographics.unknown")
      end
    end

    @age_counts = Hash[@age_groups.map { |name, group| [name, group.size] }]

    @gender_groups = @members.group_by do |member|
      case member.user_gender
      when "male" then t("statistics.statistics_demographics.male")
      when "female" then t("statistics.statistics_demographics.female")
      else t("statistics.statistics_demographics.unknown")
      end
    end
    @gender_counts = Hash[@gender_groups.map do |name, group|
      [name, group.size]
    end]
  end

  def statistics_last_login
    @members = current_organization.members.joins(:user).
               order("users.current_sign_in_at ASC NULLS FIRST")
  end

  def statistics_without_offers
    @members = current_organization.members
  end

  def statistics_type_swaps
    offers = current_organization.posts.
             where(type: "Offer").joins(:transfers, transfers: :movements).
             select("posts.tags, posts.category_id, SUM(movements.amount) as
                     sum_of_transfers, COUNT(transfers.id) as
                     count_of_transfers").
             where("movements.amount > 0").
             group("posts.tags, posts.category_id, posts.updated_at")
    total = 0.0
    offers_array = offers.map do |offer|
      if offer.category_id.blank?
        if offer.tags.blank?
          total += offer.count_of_transfers
          [[t("statistics.statistics_type_swaps.without_category"),
            t("statistics.statistics_type_swaps.without_tags"),
            offer.sum_of_transfers, offer.count_of_transfers]]
        else
          offer.tags.map do |tag|
            total += offer.count_of_transfers
            [t("statistics.statistics_type_swaps.without_category"), tag,
             offer.sum_of_transfers, offer.count_of_transfers]
          end
        end
      elsif offer.tags.blank?
        total += offer.count_of_transfers
        [[offer.category.name,
          t("statistics.statistics_type_swaps.without_tags"),
          offer.sum_of_transfers, offer.count_of_transfers]]
      else
        offer.tags.map do |tag|
          total += offer.count_of_transfers
          [offer.category.name, tag, offer.sum_of_transfers,
           offer.count_of_transfers]
        end
      end
    end.flatten(1)
    # ["Clases", "clases", 11700, 2], ["Clases", "clases", 1320, 1], ...]
    # added %
    offers_array = offers_array.map { |a| a.push(a.last / total) }
    offers_array = offers_array.group_by { |a, b| [a, b] }
    # {["Clases", "clases"]=>[["Clases", "clases", 11700, 2, 0.2],
    #  ["Clases", "clases", 1320, 1, 0.1]],,...}
    @offers = []
    offers_array.each do |cat_tag, values|
      sum_of_transfers, count_of_transfers, percent = 0, 0, 0
      values.each do |value|
        sum_of_transfers += value[2]
        count_of_transfers += value[3]
        percent += value[4]
      end
      @offers.push([cat_tag, sum_of_transfers,
                    count_of_transfers, percent].flatten)
    end
    # [["Clases", "clases", 13020, 3, 0.30],
    # ["Domestic", "coche", 2220, 1, 0.1],...]
    @offers = @offers.sort_by(&:last).reverse
  end

  protected

  def age(date_of_birth)
    now = DateTime.now
    age = now.year - date_of_birth.year
    age -= 1 if (now.month < date_of_birth.month) ||
                (now.month == date_of_birth.month &&
                 now.day < date_of_birth.day)
    age
  end
end
