class UpdateNullActiveMembersToTrue < ActiveRecord::Migration[7.2]
  def up
    # Update existing members with NULL active status to true
    Member.where(active: nil).update_all(active: true)
  end

  def down
    # This migration is safe to not reverse, as we're just setting
    # a default value for NULL records
  end
end