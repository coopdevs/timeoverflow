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

  module ClassMethods
    def all_tags
      pluck(:tags).flatten.compact.reject(&:empty?)
    end

    def tag_list
      all_tags.uniq.sort
    end

    # Builds a hash where the keys are the tags and the values are the number of
    # their occurrences
    #
    # @return [Hash<String => Integer>]
    def tag_cloud
      Hash[
        all_tags
          .group_by(&:to_s)
          .map { |tag_name, values| [tag_name, values.size] }
          .sort_by { |array| array.first.downcase }
      ]
    end

    def find_like_tag(pattern)
      all_tags.uniq.select { |t| t =~ /#{pattern}/i }
    end

    # Builds a hash where the keys are the capital letters of the tags and the
    # values are the individual tags together with the number of their
    # occurrences
    #
    # @return [Hash<Array<Array<String, Integer>>>]
    def alphabetical_grouped_tags
      tag_cloud.group_by { |tag_name, _| tag_name[0].capitalize }
    end
  end
end
