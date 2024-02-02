class AddIconNameToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :icon_name, :string

    # Initialize icon names for each category with mapping defined in #673
    icon_mapping = {
      "Acompañamiento" => "random",
      "Asesoramiento" => "briefcase",
      "Clases" => "education",
      "Estética" => "scissors",
      "Ocio" => "music",
      "Otros" => "asterisk",
      "Préstamo de herramientas, material, libros, ..." => "wrench",
      "Salud" => "apple",
      "Tareas administrativas" => "list-alt",
      "Tareas domésticas" => "shopping-cart"
    }
    Category.all.each do |category|
      category.update(icon_name: icon_mapping[category.name] || "folder-open")
    end
  end
end
