# Taggable model concern
#
# Uses postgresql string arrays to provide tags without the additional tables.
#
module Taggable
  extend ActiveSupport::Concern

  included do
    scope :tagged_with, ->(tag) { where("? = ANY (tags)", tag) }
    scope :tagged_with_rank, ->(tag) { select("*,1 as rank").tagged_with(tag) }
  end

  def tag_list
    tags && tags.join(", ")
  end

  def tag_list=(tag_list)
    self.tags = Array(tag_list.to_s.split(/,\s*/))
  end

  # class methods (stupid comment to make rubocop happy)
  module ClassMethods
    # Get list of all tags from database (array column tags) and reject eventual
    # empty values
    def all_tags
      pluck(:tags).flatten.compact.reject(&:empty?)
    end

    # Return uniq list of all tags, sorted by name of tag
    def tag_list
      all_tags.uniq.sort
    end

    # Generate tag cloud hash (tag and count of times shown) sorted by tags
    def tag_cloud
      Hash[all_tags.group_by(&:to_s).map { |k, v| [k, v.size] }.sort]
    end

    # Sort tag cloud by amount of ocurrences, descending
    def tag_cloud_desc
      tag_cloud.sort_by { |_k, v| v }.reverse
    end

    # Sort tag cloud by amount of ocurrences, ascending
    def tag_cloud_asc
      tag_cloud.sort_by { |_k, v| v }
    end

    # Return tags that matches provided regex pattern
    def find_like_tag(pattern)
      all_tags.uniq.select { |t| t =~ /#{pattern}/ }
    end

    # Return tag cloud asc grouped by 1st alpha character
    def alphabetical_grouped_tags_asc
      tag_cloud_asc.group_by { |l| l[0][0].capitalize }
    end

    # Return tag cloud desc grouped by 1st alpha character
    def alphabetical_grouped_tags_desc
      tag_cloud_desc.group_by { |l| l[0][0].capitalize }
    end
    
    # Merge selected tags
    def merge_selected_tags(new_name, selected_tags)
      selected_tags.each do |tag|
        records = tagged_with(tag)
        records.each do |r|
          r.tags.map! { |t| t.eql?(tag) ? new_name : t }
          # In order to save a changed array you need to explicitly declare it as dirty
          # See http://paweljaniak.co.za/2013/07/28/rails-4-and-postgres-arrays/
          # Also https://github.com/rails/rails/issues/14763
          r.tags_will_change!
          r.save!
        end
      end 
    end 

    # Delete selected tags 
    def delete_selected_tags(selected_tags)
      selected_tags.each do |tag|
        records = tagged_with(tag)
        records.each do |r|
          r.tags.delete(tag)
          # In order to save a changed array you need to explicitly declare it as dirty
          # See http://paweljaniak.co.za/2013/07/28/rails-4-and-postgres-arrays/
          # Also https://github.com/rails/rails/issues/14763
          r.tags_will_change! 
          r.save!
        end
      end 
    end
  end
end
