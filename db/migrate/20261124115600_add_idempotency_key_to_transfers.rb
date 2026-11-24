class AddIdempotencyKeyToTransfers < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    add_column :transfers, :idempotency_key, :string
    add_index :transfers, :idempotency_key, unique: true, algorithm: :concurrently
  end
end
