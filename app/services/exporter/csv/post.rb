module Exporter
  module CSV
    class Post
      def initialize(collection, type)
        @collection = collection
        @type = type
      end

      def run
        Exporter::CSV.run(headers, rows)
      end

      def headers
        [
          @type.model_name.human,
          User.model_name.human
        ]
      end

      def rows
        grouped_rows = []

        @collection.map do |category, posts|
          grouped_rows << [category || "-"]

          posts.each do |post|
            grouped_rows << [
              post.title,
              "#{post.user} (#{post.member_id})"
            ]
          end
        end

        grouped_rows
      end
    end
  end
end
