class SetupPgTrgm < ActiveRecord::Migration
  def self.up
    enable_extension "pg_trgm"
  end
  def self.down
    disable_extension "pg_trgm"
  end
end
