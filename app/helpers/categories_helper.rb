module CategoriesHelper
  def all_categories
    @all_categories ||= Category.all.sort_by { |a| a.name.downcase }
  end

  def categories_for_select
    all_categories.map { |cat| [cat.name, cat.id] }
  end

  def category_icon(category)
    icon_name = category.icon_name
    glyph(icon_name) if icon_name
  end
end
