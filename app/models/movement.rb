class Movement < ActiveRecord::Base
  belongs_to :user
  belongs_to :transfer

  attr_accessible :type

  def value
  	transfer.amount * sign
  end

  def sign
  	raise NotImplementedError
  end

end
