module CategoriesHelper
  def all_categories
    @all_categories ||= Category.all.sort_by { |a| a.name.downcase }
  end

  def categories_for_select
    all_categories.map { |cat| [cat.name, cat.id] }
  end

  # NOTE This is far from ideal :) It relies on DB data editable via the /admin
  # section or the console. Maybe Category should be a read-only model?
  def category_icon(category)
    icon_name =
      case category.name
      when 'Acompañamiento'
        :random
      when 'Asesoramiento'
        :briefcase
      when 'Clases'
        :education
      when 'Estética'
        :scissors
      when 'Ocio'
        :music
      when 'Otros'
        :asterisk
      when 'Préstamo de herramientas, material, libros, ...'
        :wrench
      when 'Salud'
        :apple
      when 'Tareas administrativas'
        :list_alt
      when 'Tareas domésticas'
        :shopping_cart
      else
        :folder_open
      end

    glyph(icon_name)
  end
end
