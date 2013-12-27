class Document < ActiveRecord::Base
  belongs_to :documentable, polymorphic: true
end
