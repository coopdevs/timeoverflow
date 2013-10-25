ActiveRecord::Base.connection.execute("CREATE EXTENSION IF NOT EXISTS hstore;") rescue nil
