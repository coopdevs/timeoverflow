module Report
  module Pdf
    class Base
      def name
        @decorator.name(:pdf)
      end

      def mime_type
        Mime[:pdf]
      end

      def run
        Report::Pdf.run(@decorator.headers, @decorator.rows)
      end
    end
  end
end
