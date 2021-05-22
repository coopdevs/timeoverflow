module Report
  module Csv
    class Detailed < Base
      def initialize(org)
        self.decorator = Report::DetailedDecorator.new(org)
      end
    end
  end
end
