class TransferCreator
  
  def initialize(source:, destination:, amount:, reason:, post_id:)
  	 @source = source
     @destination = destination
     @amount = amount
     @reason = reason
     @post_id = post_id
  end

  attr_reader :transfer
  
  def create!
  	@transfer = Transfer.new(
	    source: @source,
      destination: @destination,
      amount: @amount,
      reason: @reason,
      post_id: @post_id
    )
  	@transfer.save! && notify_by_email
  end

  def notify_by_email
  	# mail notificación pago
  	#Todo: check accountable as organization
    PaymentNotifier.transfer_source(@source.accountable.user, @destination.accountable.display_name_with_uid, @transfer.amount.to_f/3600).deliver_now
    PaymentNotifier.transfer_destination(@destination.accountable.user, @source.accountable.display_name_with_uid, @transfer.amount.to_f/3600).deliver_now
  end
end