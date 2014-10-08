module Taggable
  extend ActiveSupport::Concern

  included do
    scope :tagged_with, ->(tag){ where("? = ANY (tags)", tag) }
    scope :tagged_like, ->(tag_pat){ where("tags LIKE ?", "%#{tag_pat}%")}
  end

  def tag_list
    tags && tags.join(", ")
  end

  def tag_list=(tag_list)
    self.tags = Array(tag_list.to_s.split(/,\s*/))
  end

  module ClassMethods

    def all_tags
      pluck(:tags).flatten.compact
    end

    def tag_list
      all_tags.uniq.sort
    end

    def tag_cloud
      Hash[all_tags.group_by(&:to_s).values.map {|v| [v.first, v.size]}.sort]
    end


  end

end
