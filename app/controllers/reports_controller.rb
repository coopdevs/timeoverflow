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
    # intercambios con el banco
    @total_hours += current_organization.account.movements.map{ |a| (a.amount > 0)? a.amount : 0 }.inject(0,:+)
    # periodo a mostrar actividades globales
    ini, fin = params[:ini], params[:fin]
    if ini.present?
      # calculo numero de meses
      num_months = (fin.to_date.year * 12 + fin.to_date.month) - (ini.to_date.year * 12 + ini.to_date.month) + 1
      date = ini.to_date
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
end

