class AddTsvectorColumnToPost < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE posts ADD COLUMN tsv tsvector;

      CREATE FUNCTION posts_trigger() RETURNS trigger AS $$
      begin
        new.tsv :=
          to_tsvector('simple', unaccent(coalesce(new.title::text, ''))) ||
          to_tsvector('simple', unaccent(coalesce(new.description::text, ''))) ||
          to_tsvector('simple', unaccent(coalesce(new.tags::text, '')));
        return new;
      end
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON posts FOR EACH ROW EXECUTE PROCEDURE posts_trigger();
    SQL

    add_index :posts, :tsv, using: "gin"
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate ON posts;
      DROP FUNCTION posts_trigger();
    SQL

    remove_index :posts, :tsv
    remove_column :posts, :tsv
  end
end
