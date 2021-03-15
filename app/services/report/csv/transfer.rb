module Report
  module Csv
    class Transfer < Base
      def initialize(org, collection)
        self.decorator = Report::TransferDecorator.new(org, collection)
      end
    end
  end
end
