class DeleteIdentityDocumentFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :identity_document
  end
end
