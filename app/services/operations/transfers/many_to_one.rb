module Operations
  module Transfers
    class ManyToOne < Base
      def transfers
        sources.map do |source|
          build_transfer(
            source: source,
            destination: destination
          )
        end
      end

      private

      def sources
        from
      end

      def destination
        to.first
      end
    end
  end
end
