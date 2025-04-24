class CreateOrganizationAlliances < ActiveRecord::Migration[7.2]
  def change
    create_table :organization_alliances do |t|
      t.references :source_organization, foreign_key: { to_table: :organizations }
      t.references :target_organization, foreign_key: { to_table: :organizations }
      t.integer :status, default: 0
      
      t.timestamps
    end
    
    add_index :organization_alliances, [:source_organization_id, :target_organization_id], 
              unique: true, name: 'index_org_alliances_on_source_and_target'
  end
end