class AddNotNullConstraintToMemberUidInMembers < ActiveRecord::Migration[6.1]
  def change
    change_column_null :members, :member_uid, false
  end
end
