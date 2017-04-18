# blatatly taken from the db:migrate:status task...
require 'spec_helper'

describe "database schema" do
  # we have supposedly loaded the schema but not run the migrations - as
  # configured in travis.yml
  it "is up to date" do
    db_list = ActiveRecord::Base.connection
      .select_values("SELECT version FROM schema_migrations")
      .sort

    file_list = Dir[File.join(Rails.root, 'db', 'migrate')]
      .map(&/(\d{14})_(.+)\.rb/.method(:match))
      .compact
      .map { |m| m[1] }
      .sort
    
    expect(file_list).to eq db_list
  end
end
