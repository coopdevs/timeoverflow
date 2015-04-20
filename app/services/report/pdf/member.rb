module Report
  module PDF
    class Member
      def initialize(org, collection)
        @collection = collection
        @decorator = MemberReportDecorator.new(org, @collection)
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
