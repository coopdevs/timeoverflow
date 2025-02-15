class ApplicationRecord < ActiveRecord::Base
  include Ransackable

  self.abstract_class = true
end
