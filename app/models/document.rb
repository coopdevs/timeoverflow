class Document < ApplicationRecord
  belongs_to :documentable, polymorphic: true, optional: true

  translates :title, :content

  def self.terms_and_conditions
    where(label: "t&c", documentable_id: nil).first
  end
end
