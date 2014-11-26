class AddTagsToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :tags, :text, array: true
    add_index :posts, :tags, using: :gin

    say "Tag column added"

    ActiveRecord::Base.connection.execute(
    <<-SQL
    WITH prepared_tags AS (
      SELECT "posts"."id" AS "id", array_agg("tags"."name") AS "tags"
      FROM "posts"
      INNER JOIN "taggings" ON "taggings"."taggable_id" = "posts"."id"
        AND "taggings"."taggable_type" = 'Post'
      INNER JOIN "tags" ON "tags"."id" = "taggings"."tag_id"
      GROUP BY "posts"."id"
    )
    UPDATE "posts"
    SET "tags" = "prepared_tags"."tags"
    FROM "prepared_tags"
    WHERE "posts"."id" = "prepared_tags"."id"
    SQL
    )

    say "Data migrated"

    drop_table :taggings
    drop_table :tags

    say "acts_as_taggable_on tables removed"

  end

  def down
    say "Current tags will be lost until someone finds how to invert the above query."

    create_table :tags do |t|
      t.string :name
    end

    create_table :taggings do |t|
      t.references :tag

      # You should make sure that the column created is
      # long enough to store the required class names.
      t.references :taggable, :polymorphic => true
      t.references :tagger, :polymorphic => true

      # Limit is created to prevent MySQL error on index
      # length for MyISAM table type: http://bit.ly/vgW2Ql
      t.string :context, :limit => 128

      t.datetime :created_at
    end

    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type, :context]


    remove_column :posts, :tags
    remove_index :posts, :tags
  end
end


