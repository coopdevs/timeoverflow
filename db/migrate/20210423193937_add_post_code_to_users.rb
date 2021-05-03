class AddPostCodeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :postcode, :string
  end
end
