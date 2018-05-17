# This migration does not use Rails ActiveRecord ORM DSL since
# it doesn't provide data integrity (foreign key) for polymorphic models.
#
# The technique applied is called Exclusive Belongs To (AKA Exclusive Arc)
#
# Please read the following article for more details:
# https://hashrocket.com/blog/posts/modeling-polymorphic-associations-in-a-relational-database
#
class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.integer :action, null:false
      t.integer :post_id
      t.integer :member_id
      t.integer :transfer_id
      t.timestamps
    end

    add_foreign_key :events, :posts, name: 'events_post_id_fkey'
    add_foreign_key :events, :members, name: 'events_member_id_fkey'
    add_foreign_key :events, :transfers, name: 'events_transfer_id_fkey'

    add_index :events, :post_id, unique: true, where: 'post_id IS NOT NULL'
    add_index :events, :member_id, unique: true, where: 'member_id IS NOT NULL'
    add_index :events, :transfer_id, unique: true, where: 'transfer_id IS NOT NULL'

    execute <<-SQL
      ALTER TABLE events
        ADD CHECK(action IN (0, 1)),
        ADD CHECK(
          (
            (post_id IS NOT NULL)::integer +
            (member_id IS NOT NULL)::integer +
            (transfer_id IS NOT NULL)::integer
          ) = 1
        );
    SQL
  end

  def down
    drop_table :events
  end
end
