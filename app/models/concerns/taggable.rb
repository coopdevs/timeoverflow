module Taggable
  extend ActiveSupport::Concern

  included do
    scope :tagged_with, ->(tag){ where("? = ANY (tags)", tag) }
    scope :tagged_with_rank, ->(tag){ select("*,1 as rank").where("? = ANY (tags)", tag) }
  end

  def tag_list
    tags && tags.join(", ")
  end

  def tag_list=(tag_list)
    self.tags = Array(tag_list.to_s.split(/,\s*/))
  end

  module ClassMethods

    def all_tags
      # if a class_method :get_tags has been provided to get list of tags
      # then use that method (eventually with a filter)
      # otherwise use pluck to get uniq list of tags
      t=(self.respond_to?(:get_tags))? self.get_tags : pluck(:tags)

      # then flatten (one dimensional array out of multiple ones),
      # get uniq elements sorted
      # then compact(remove nils) and then reject empty elements ('')
      # and then return result
      t.flatten.uniq.compact.reject(&:empty?)
    end

    def tag_list
      all_tags.sort
    end

    def tag_cloud
      Hash[all_tags.group_by(&:to_s).values.map {|v| [v.first, v.size]}.sort]
    end

    def find_like_tag(pattern)
       all_tags.select{|t| t=~ /#{pattern}/}
    end

    def alphabetical_grouped_tags
       tag_cloud.group_by{ |l| l[0][0].capitalize }
    end
  end

end
