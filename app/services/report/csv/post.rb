module Report
  module Csv
    class Post < Base
      def initialize(org, collection, type)
        @decorator = PostReportDecorator.new(org, collection, type)
      end
    end
  end
end
