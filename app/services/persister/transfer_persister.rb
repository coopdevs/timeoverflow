module Persister
  class TransferPersister
    attr_accessor :transfer, :organization

    def initialize(transfer, organization)
      @transfer = transfer
      @organization = organization
    end

    def save
      ::ActiveRecord::Base.transaction do
        transfer.save!
        create_save_event!
        transfer
      end
    rescue ActiveRecord::RecordInvalid => _exception
      false
    end

    def update_attributes(params)
      ::ActiveRecord::Base.transaction do
        transfer.update_attributes!(params)
        create_update_event!
        transfer
      end
    rescue ActiveRecord::RecordInvalid => _exception
      false
    end

    private

    def create_save_event!
      ::Event.create! action: :created, transfer: transfer, organization: organization
    end

    def create_update_event!
      ::Event.create! action: :updated, transfer: transfer, organization: organization
    end
  end
end
