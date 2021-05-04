module CategoriesHelper
  def all_categories
    @all_categories ||= Category.all.sort_by { |a| a.name.downcase }
  end

  def categories_for_select
    all_categories.map { |cat| [cat.name, cat.id] }
  end
end
