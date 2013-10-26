begin
  ActiveRecord::Base.connection.execute("CREATE EXTENSION IF NOT EXISTS hstore;")
  ActiveRecord::Base.connection.execute("CREATE EXTENSION IF NOT EXISTS pg_trgm;")
rescue PG::ConnectionBad
end
