# Taggable model concern
#
# Uses postgresql string arrays to provide tags without the additional tables.
#
module Taggable
  extend ActiveSupport::Concern

  included do
    scope :tagged_with, ->(tag) { where("? = ANY (tags)", tag) }
  end

  def tag_list
    tags && tags.join(", ")
  end

  def tag_list=(tag_list)
    self.tags = tag_list.reject(&:empty?)
  end

  # class methods (stupid comment to make rubocop happy)
  module ClassMethods
    def all_tags
      pluck(:tags).flatten.compact.reject(&:empty?)
    end

    def tag_list
      all_tags.uniq.sort
    end

    def tag_cloud
      Hash[
        all_tags
        .group_by(&:to_s)
        .map { |k, v| [k, v.size] }
        .sort_by { |array| array.first.downcase }
      ]
    end

    def find_like_tag(pattern)
      all_tags.uniq.select { |t| t =~ /#{pattern}/i }
    end

    def alphabetical_grouped_tags
      tag_cloud.group_by { |tag_name, _| tag_name[0].capitalize }
    end
  end
end
