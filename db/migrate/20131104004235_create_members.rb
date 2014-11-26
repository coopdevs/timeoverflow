class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.references :user, index: true
      t.references :organization, index: true
      t.boolean :manager

      t.timestamps
    end
  end
end
