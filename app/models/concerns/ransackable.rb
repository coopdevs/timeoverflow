module Ransackable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(auth_object = nil)
      authorizable_ransackable_attributes
    end

    def ransackable_associations(auth_object = nil)
      authorizable_ransackable_associations
    end
  end
end
