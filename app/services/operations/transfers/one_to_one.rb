module Operations
  module Transfers
    class OneToOne < Base
      def transfers
        [build_transfer(
          source: source,
          destination: destination
        )]
      end

      private

      def source
        from.first
      end

      def destination
        to.first
      end
    end
  end
end
