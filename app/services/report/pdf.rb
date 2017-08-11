module Report
  module PDF
    MIME_TYPE = Mime::PDF

    def self.run(headers, rows, custom_options = nil)
      pdf = Prawn::Document.new(options.merge(custom_options))
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
