module Report
  module PDF
    class Post
      def initialize(collection, type)
        @collection = collection
        @type = type
      end

      def run
        post_report = PostReportDecorator.new(@collection, @type)
        Report::PDF.run(post_report.headers, post_report.rows)
      end
    end
  end
end
