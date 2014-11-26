class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username,        :null => false  # if you use another field as a username, for example email, you can safely remove this field.
      t.string :email,           :null => false # if you use this field as a username, you might want to make it :null => false.
      t.string :password_digest, :default => nil
      t.date :date_of_birth
      t.string :identity_document
      t.string :member_code
      t.references :organization
      t.string :phone
      t.string :alt_phone
      t.text :address
      t.date :registration_date
      t.integer :registration_number
      t.boolean :admin
      t.boolean :superadmin

      t.timestamps
    end

    add_index :users, :email
    add_index :users, :organization_id
  end

end


