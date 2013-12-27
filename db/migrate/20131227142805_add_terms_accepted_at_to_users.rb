class AddTermsAcceptedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :terms_accepted_at, :datetime
  end
end
