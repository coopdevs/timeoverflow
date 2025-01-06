class AddHighlightedToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :highlighted, :boolean, default: false
  end
end
