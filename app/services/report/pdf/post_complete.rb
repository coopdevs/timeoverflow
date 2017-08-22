module Report
  module PDF
    class PostComplete
      def initialize(org, collection)
        @collection = collection
        @decorator = PostCompleteReportDecorator.new(org, @collection)
      end

      def name
        @decorator.name(:pdf)
      end

      def mime_type
        Report::PDF::MIME_TYPE
      end

      def run
        Report::PDF.run(@decorator.headers, @decorator.rows, { page_layout: :landscape })
      end
    end
  end
end
