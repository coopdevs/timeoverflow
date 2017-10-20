class TransferCompleteReportDecorator
  def initialize(org, collection)
    @org = org
    @collection = collection
  end

  def name(extension)
    "#{@org.name}_"\
    "#{Date.today}."\
    "#{extension}"
  end

  def headers
    [
      Post.human_attribute_name(:id),
      Post.human_attribute_name(:title),
      Post.human_attribute_name(:description),
      Category.model_name.human,
      Post.human_attribute_name(:type),
      User.model_name.human,
      "N",
      Post.human_attribute_name(:created_at),
      Post.human_attribute_name(:updated_at),
      Post.human_attribute_name(:tags)
    ]
  end

  def rows
    @collection.map do |post|
      [
        post.id.to_s,
        post.title.to_s,
        post.description.to_s,
        post.category_name.to_s,
        post.model_name.human.to_s,
        post.user.to_s,
        post.member_uid.to_s,
        post.created_at.to_formatted_s(:db),
        post.updated_at.to_formatted_s(:db),
        post.tags.to_s
      ]
    end
  end
end
