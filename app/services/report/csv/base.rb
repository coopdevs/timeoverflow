module Report
  module Csv
    class Base
      def name
        @decorator.name(:csv)
      end

      def mime_type
        Mime[:csv]
      end

      def run
        Report::Csv.run(@decorator.headers, @decorator.rows)
      end
    end
  end
end
