module Persister
  class TransferPersister
    attr_accessor :transfer

    def initialize(transfer)
      @transfer = transfer
    end

    def save
      transfer.save
    end
  end
end
