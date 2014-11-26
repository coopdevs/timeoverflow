class AddNewFieldsToOrganization < ActiveRecord::Migration
  def change
    change_table :organizations do |t| 
      t.string :email
      t.string :phone
      t.string :web
      t.text :public_opening_times
      t.text :description
      t.text :address
      t.string :neighborhood
      t.string :city
      t.string :domain
    end
  end
end
