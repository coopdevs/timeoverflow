class PostReportDecorator
  def initialize(org, collection, type)
    @org = org
    @collection = collection
    @type = type
  end

  def name(extension)
    "#{@org.name}_"\
    "#{@type.model_name.human(count: :many)}_"\
    "#{Date.today}."\
    "#{extension}"
  end

  def headers
    [
      @type.model_name.human,
      User.model_name.human
    ]
  end

  def rows
    grouped_rows = []

    @collection.each do |category, posts|
      grouped_rows << [category.try(:name) || "-", ""]

      posts.each do |post|
        grouped_rows << [
          post.title,
          "#{post.user} (#{post.member_uid})"
        ]
      end
    end

    grouped_rows
  end
end
