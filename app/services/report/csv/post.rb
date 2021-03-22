module Report
  module Csv
    class Post < Base
      def initialize(org, collection, type)
        self.decorator = Report::PostDecorator.new(org, collection, type)
      end
    end
  end
end
