class ChangeIndexOnEvents < ActiveRecord::Migration
  def change
    remove_index :events, :post_id
    remove_index :events, :member_id
    remove_index :events, :transfer_id

    add_index :events, :post_id, where: 'post_id IS NOT NULL'
    add_index :events, :member_id, where: 'member_id IS NOT NULL'
    add_index :events, :transfer_id, where: 'transfer_id IS NOT NULL'
  end
end
