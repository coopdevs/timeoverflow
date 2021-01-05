module Report
  module Csv
    class Post
      def initialize(org, collection, type)
        @collection = collection
        @type = type
        @decorator = PostReportDecorator.new(org, @collection, @type)
      end

      def name
        @decorator.name(:csv)
      end

      def mime_type
        Report::Csv::MIME_TYPE
      end

      def run
        Report::Csv.run(@decorator.headers, @decorator.rows)
      end
    end
  end
end
