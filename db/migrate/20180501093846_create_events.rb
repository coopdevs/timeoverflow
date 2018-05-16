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
    execute <<-SQL
      CREATE TABLE events (
        id          serial PRIMARY KEY,
        action      integer NOT NULL,
        post_id     integer REFERENCES posts,
        member_id   integer REFERENCES members,
        transfer_id integer REFERENCES transfers,
        created_at  timestamp without time zone,
        updated_at  timestamp without time zone,
        CHECK(action IN (0, 1)),
        CHECK(
          (
            (post_id IS NOT NULL)::integer +
            (member_id IS NOT NULL)::integer +
            (transfer_id IS NOT NULL)::integer
          ) = 1
        )
      );

      CREATE UNIQUE INDEX ON events (post_id) WHERE post_id IS NOT NULL;
      CREATE UNIQUE INDEX ON events (member_id) WHERE member_id IS NOT NULL;
      CREATE UNIQUE INDEX ON events (transfer_id) WHERE transfer_id IS NOT NULL;
    SQL
  end

  def down
    drop_table :events
  end
end
