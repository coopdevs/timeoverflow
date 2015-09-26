class Document < ActiveRecord::Base
  belongs_to :documentable, polymorphic: true

  scope :platform_tnc_documents, -> {
    where(label: "t&c", documentable_id: nil)
  }


  def self.terms_and_conditions
    platform_tnc_documents.first
  end
end
