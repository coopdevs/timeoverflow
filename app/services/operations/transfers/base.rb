module Operations
  module Transfers
    # Base class for the transfer operations. Each subclass must implement the
    # "transfers" method, and call "build_transfer" any number of times
    # depending on the desired behavior.
    class Base
      def initialize(transfer_params:, from:, to:)
        self.transfer_params = transfer_params
        self.from = from
        self.to = to
      end

      def perform
        ::ActiveRecord::Base.transaction do
          transfers.each do |transfer|
            persister = ::Persister::TransferPersister.new(transfer)
            raise ActiveRecord::Rollback unless persister.save
          end
        end
      end

      protected

      attr_reader :transfer_params, :from, :to

      private

      attr_writer :from, :to, :transfer_params

      # Template method, use "build_transfer" method to ease the instantiation
      # of Transfers with the correct params.
      #
      # @return [Array<Transfer>]
      def transfers
        raise NotImplementedError
      end

      def build_transfer(source:, destination:)
        ::Transfer.new(transfer_params_for(
          source: source,
          destination: destination
        ))
      end

      def transfer_params_for(source:, destination:)
        transfer_params.merge(source: source, destination: destination)
      end
    end
  end
end
