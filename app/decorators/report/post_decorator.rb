class Report::PostDecorator
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
      Post.human_attribute_name(:tag_list),
      User.model_name.human,
      Post.human_attribute_name(:created_at)
    ]
  end

  def rows
    grouped_rows = []

    @collection.each do |category, posts|
      grouped_rows << ["", category.try(:name) || "-", "", "", ""]

      posts.each do |post|
        grouped_rows << [
          post.title,
          post.tag_list.to_s,
          "#{post.user} (#{post.member_uid})",
          post.created_at.to_s
        ]
      end
    end

    grouped_rows
  end
end
