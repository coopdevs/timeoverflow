class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :documentable_id
      t.string :documentable_type
      t.text :title
      t.text :content
      t.string :label

      t.timestamps
    end
    add_index :documents, [:documentable_id, :documentable_type]
    add_index :documents, :label
  end
end
