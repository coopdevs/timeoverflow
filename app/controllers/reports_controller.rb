class ReportsController < ApplicationController
  before_filter :authenticate_user!

  layout "report", except: [:statistics_global_activity, :statistics_inactive_users, :statistics_demographics, :statistics_last_login, :statistics_without_offers, :statistics_type_swaps]

  def user_list
    @members = current_organization.members.includes(:user).order("members.member_uid")
  end

  def post_list
    @post_type = (params[:type] || "offer").capitalize.constantize
    @posts = current_organization.posts.where(type: @post_type).group_by(&:category).to_a.sort_by {|c, p| c.try(:name) || ""}
  end

  def statistics_global_activity
    @members = current_organization.members
    @total_hours = num_movements = 0
    @members.each do |m|
      num_movements += m.account.movements.count
      @total_hours += m.account.movements.map{ |a| (a.amount > 0) ? a.amount : 0 }.inject(0,:+)
    end
    # cada intercambio implica dos movimientos
    @num_swaps = (num_movements + current_organization.account.movements.count)/2
    # intercambios con el banco
    @total_hours += current_organization.account.movements.map{ |a| (a.amount > 0)? a.amount : 0 }.inject(0,:+)
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
      num_months.times{
        @months_names.push(date.strftime("%B"))
        @user_reg_months.push(@members.by_month(date).count)
        # movimientos de los miembros en dicho mes
        swaps_members = @members.map{|a| a.account.movements.by_month(date)}
        # movimimentos del banco
        swaps_organization = current_organization.account.movements.by_month(date)
        # numero de movimientos totales
        sum_swaps = (swaps_members.flatten.count + swaps_organization.count)/2
        @num_swaps_months.push(sum_swaps)
        # horas intercambiadas
        sum_hours = 0
        swaps_members.flatten.each do |s|
          sum_hours += (s.amount > 0)? s.amount : 0
        end
        sum_hours += swaps_organization.map{ |a| (a.amount > 0)? a.amount : 0 }.inject(0,:+)
        sum_hours = sum_hours / 3600.0 if sum_hours > 0
        @hours_swaps_months.push(sum_hours)
        date = date.next_month
      }
    end
  end

  def statistics_inactive_users
    @members = current_organization.members
  end

  def statistics_demographics
    @members = current_organization.members

    @age_groups = @members.group_by { |member|
      case (age(member.user.date_of_birth.presence) rescue nil)
      when 0..17 then ' -17'
      when 18..24 then '18-24'
      when 25..34 then '25-34'
      when 35..44 then '35-44'
      when 45..54 then '45-54'
      when 55..64 then '55-64'
      when 65..100 then '65+'
      else 'Desconocida'
      end
    }
    @age_counts = Hash[@age_groups.map { |name, group| [name, group.size] }]

    @gender_groups = @members.group_by { |member|
      case member.user.gender
      when 'male' then 'Male'
      when 'female' then 'Female'
      else 'Desconocido'
      end
    }
    @gender_counts = Hash[@gender_groups.map { |name, group| [name, group.size] }]
  end

  def statistics_last_login
    @members = current_organization.members.joins(:user).order('users.current_sign_in_at DESC NULLS FIRST')
  end

  def statistics_without_offers
    @members = current_organization.members
  end

  def statistics_type_swaps
    offers = current_organization.offers
    @offers_by_tag = {}
    time, swaps = 0, 0

    offers.each do |offer|
      offer.tags.size.times do |index|
        category = offer.category.name
        swaps = offer.transfers.count
        time = offer.movements.map{|m| (m.amount > 0)? m.amount : 0 }.inject(0,:+)

        hash_values = @offers_by_tag["#{offer.tags[index]}"]
        if hash_values.blank?
          hash_values = {category: category, swaps: swaps, time: time}
        else
          if hash_values[:category] == offer.category.name
            hash_values[:swaps] += offer.transfers.count
            hash_values[:time] += offer.movements.map{|m| (m.amount > 0)? m.amount : 0 }.inject(0,:+)
          else
            hash_values.merge!({category: category, swaps: swaps, time: time})
          end
        end
        @offers_by_tag["#{offer.tags[index]}"] = hash_values
      end
    end
    total_swaps = @offers_by_tag.map{|k,v| v[:swaps]}.inject(0.0,:+)
    @offers_by_tag = @offers_by_tag.each{|k,v| v[:percent] = v[:swaps]/total_swaps*100}.sort_by{|k,v| v[:percent]}.reverse
  end

  protected

  def age date_of_birth
    now = DateTime.now
    age = now.year - date_of_birth.year
    age -= 1 if((now.month < date_of_birth.month) || (now.month == date_of_birth.month && now.day < date_of_birth.day))
    age
  end

end
