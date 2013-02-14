class AddRegNumberSeqToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :reg_number_seq, :integer
  end
end
