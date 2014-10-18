class RemoveMemberFieldsFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :member_code
    remove_column :users, :organization_id
    remove_column :users, :registration_date
    remove_column :users, :registration_number
    remove_column :users, :admin
  end
end
