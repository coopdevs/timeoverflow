class EnableUnaccentExtension < ActiveRecord::Migration
  def up
    enable_extension "unaccent"
  end

  def down
    disable_extension "unaccent"
  end
end
