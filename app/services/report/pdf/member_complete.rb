module Report
  module PDF
    class MemberComplete
      def initialize(org, collection)
        @collection = collection
        @decorator = MemberCompleteReportDecorator.new(org, @collection)
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
