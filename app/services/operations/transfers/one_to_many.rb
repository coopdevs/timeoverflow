module Operations
  module Transfers
    class OneToMany < Base
      def transfers
        destinations.map do |destination|
          build_transfer(
            source: source,
            destination: destination
          )
        end
      end

      private

      def source
        from.first
      end

      def destinations
        to
      end
    end
  end
end
