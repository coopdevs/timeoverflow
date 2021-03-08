module Report
  module Pdf
    class Post < Base
      def initialize(org, collection, type)
        self.decorator = PostReportDecorator.new(org, collection, type)
      end
    end
  end
end
