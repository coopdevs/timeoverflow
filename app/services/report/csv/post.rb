module Report
  module CSV
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
        Report::CSV::MIME_TYPE
      end

      def run
        Report::CSV.run(@decorator.headers, @decorator.rows)
      end
    end
  end
end
