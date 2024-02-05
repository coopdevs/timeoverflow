class AddUniqueIndexOnMemberUidInMembers < ActiveRecord::Migration[6.1]
  def change
    add_index :members, [:organization_id, :member_uid], unique: true
  end
end
