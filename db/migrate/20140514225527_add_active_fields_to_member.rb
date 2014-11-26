class AddActiveFieldsToMember < ActiveRecord::Migration
  def change
    add_column :members, :active, :boolean, :default => true
  end
end
