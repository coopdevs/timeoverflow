module Report
  module Pdf
    MIME_TYPE = Mime[:pdf]

    def self.run(headers, rows)
      pdf = Prawn::Document.new(options)
      pdf.table [headers] + rows

      pdf.render
    end

    def self.options
      {
        page_size: "A4",
        margin: 30
      }
    end
  end
end
