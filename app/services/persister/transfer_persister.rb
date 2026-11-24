module Persister
  class TransferPersister
    attr_accessor :transfer

    def initialize(transfer)
      @transfer = transfer
    end

    # Returns the transfer, or false if it's invalid. If a transfer with the
    # same idempotency key already exists (the same form submitted twice), no
    # new transfer is created and the existing one is returned.
    def save
      ::ActiveRecord::Base.transaction(requires_new: true) do
        transfer.save!
        create_save_event!
        transfer
      end
    rescue ActiveRecord::RecordInvalid => _exception
      false
    rescue ActiveRecord::RecordNotUnique => exception
      existing = duplicate
      raise exception unless existing

      self.transfer = existing
    end

    def update(params)
      ::ActiveRecord::Base.transaction do
        transfer.update!(params)
        create_update_event!
        transfer
      end
    rescue ActiveRecord::RecordInvalid => _exception
      false
    end

    private

    def duplicate
      transfer.idempotency_key.presence &&
        ::Transfer.find_by(idempotency_key: transfer.idempotency_key)
    end

    def create_save_event!
      ::Event.create! action: :created, transfer: transfer
    end

    def create_update_event!
      ::Event.create! action: :updated, transfer: transfer
    end
  end
end
