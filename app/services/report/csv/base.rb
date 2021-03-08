require "csv"

module Report
  module Csv
    class Base
      attr_accessor :decorator

      def name
        decorator.name(:csv)
      end

      def mime_type
        Mime[:csv]
      end

      def run
        ::CSV.generate do |csv|
          csv << decorator.headers

          decorator.rows.each do |row|
            csv << row
          end
        end
      end
    end
  end
end
