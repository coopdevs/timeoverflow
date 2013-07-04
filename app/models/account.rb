class Account < ActiveRecord::Base
  belongs_to :accountable, polymorphic: true
  has_many :movements

  def update_balance
    new_balance = movements.sum(:amount)
    update_attributes balance: new_balance, flagged: !allowed?(new_balance)
  end

  def allowed?(new_balance)
    new_balance < (max_allowed_balance || Float::INFINITY) and
      new_balance > (min_allowed_balance || -Float::INFINITY)
  end

  def allowance
    min_allowed_balance ? [0, balance - min_allowed_balance].min : Float::INFINITY
  end

  def to_s
    "#{accountable}"
  end
end
