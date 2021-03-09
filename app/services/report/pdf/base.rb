module Report
  module Pdf
    class Base
      attr_accessor :decorator

      def name
        decorator.name(:pdf)
      end

      def mime_type
        Mime[:pdf]
      end

      def run
        pdf = Prawn::Document.new({ page_size: "A4", margin: 30 })
        pdf.table [decorator.headers] + decorator.rows

        pdf.render
      end
    end
  end
end
