class AddAmountConstraintToMovements < ActiveRecord::Migration
  def change
    # Destroy movements (and parent transfer) with amount equal to 0
    Movement.includes(:transfer).where(amount: 0).find_each do |movement|
      movement.transfer&.destroy
    end

    execute 'ALTER TABLE movements ADD CONSTRAINT non_zero_amount CHECK(amount != 0)'
  end
end
