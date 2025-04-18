class AddCrossBankFieldsToTransfers < ActiveRecord::Migration[7.2]
  def change
    add_column :transfers, :meta, :jsonb, default: {}, null: false
  end
end
