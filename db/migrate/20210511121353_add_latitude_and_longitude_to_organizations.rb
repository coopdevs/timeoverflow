class AddLatitudeAndLongitudeToOrganizations < ActiveRecord::Migration[6.1]
  def change
    change_table :organizations, bulk: true do |t|
      t.decimal :latitude
      t.decimal :longitude
    end
  end
end
