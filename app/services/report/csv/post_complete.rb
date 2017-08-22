module Report
  module CSV
    class PostComplete
      def initialize(org, collection)
        @collection = collection
        @decorator = PostCompleteReportDecorator.new(org, @collection)
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
