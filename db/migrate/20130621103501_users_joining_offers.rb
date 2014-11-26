class UsersJoiningOffers < ActiveRecord::Migration
  def change
    create_table :user_joined_post do |t|
      t.integer :user_id
      t.integer :post_id
    end
  end
end
