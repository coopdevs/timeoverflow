require "csv"

module Report
  module Csv
    def self.run(headers, rows)
      ::CSV.generate do |csv|
        csv << headers
        rows.each do |row|
          csv << row
        end
      end
    end
  end
end
