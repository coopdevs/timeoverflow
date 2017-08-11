module Report
  module CSV
    class MemberComplete
      def initialize(org, collection)
        @collection = collection
        @decorator = MemberCompleteReportDecorator.new(org, @collection)
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
