module Report
  module Csv
    class Member
      def initialize(org, collection)
        @collection = collection
        @decorator = MemberReportDecorator.new(org, @collection)
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
