module Report
  module CSV
    class Post
      def initialize(collection, type)
        @collection = collection
        @type = type
      end

      def run
        post_report = PostReportDecorator.new(@collection, @type)
        Report::CSV.run(post_report.headers, post_report.rows)
      end
    end
  end
end
