class AddFieldsFromUserToMember < ActiveRecord::Migration
  def change
    add_column :members, :entry_date, :date
    add_column :members, :member_uid, :integer
  end
end
