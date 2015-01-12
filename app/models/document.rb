class Document < ActiveRecord::Base
  belongs_to :documentable, polymorphic: true

  def self.terms_and_conditions
    where(label: "t&c", documentable_id: nil).first
  end
end
