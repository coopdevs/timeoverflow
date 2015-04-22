module Report
  module PDF
    class Post
      def initialize(org, collection, type)
        @collection = collection
        @type = type
        @decorator = PostReportDecorator.new(org, @collection, @type)
      end

      def name
        @decorator.name(:pdf)
      end

      def mime_type
        Report::PDF::MIME_TYPE
      end

      def run
        Report::PDF.run(@decorator.headers, @decorator.rows)
      end
    end
  end
end
