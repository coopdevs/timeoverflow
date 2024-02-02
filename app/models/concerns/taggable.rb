# Taggable model concern
#
# Uses postgresql string arrays to provide tags without the additional tables.
#
module Taggable
  extend ActiveSupport::Concern

  included do
    scope :tagged_with, ->(tag) { where("? = ANY (#{table_name}.tags)", tag) }
  end

  def tag_list
    tags && tags.join(", ")
  end

  def tag_list=(new_tags)
    new_tags = new_tags.split(",").map(&:strip) if new_tags.is_a?(String)

    self.tags = new_tags.reject(&:empty?)
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
        all_tags.
        group_by(&:to_s).
        map { |tag_name, values| [tag_name, values.size] }.
        sort_by { |array| array.first.downcase }
      ]
    end

    def find_like_tag(pattern)
      transliterated_pattern = pattern.present? ? ActiveSupport::Inflector.transliterate(pattern) : ""
      all_tags.uniq.select do |t|
        ActiveSupport::Inflector.transliterate(t) =~ /#{transliterated_pattern}/i
      end
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
