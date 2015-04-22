class AddOrganizationIdToAcconts < ActiveRecord::Migration
  def change
    reversible do |direction|
      direction.up do
        add_reference :accounts, :organization, index: true

        execute <<-SQL
          UPDATE accounts
            SET organization_id = accountable_id
            WHERE accounts.accountable_type = 'Organization'
          ;
          UPDATE accounts
            SET organization_id = members.organization_id
            FROM members
            WHERE accounts.accountable_type = 'Member'
            AND accounts.accountable_id = members.id
          ;
        SQL

        add_foreign_key :accounts, :organizations
      end

      direction.down do
        remove_foreign_key :accounts, :organizations
        remove_reference :accounts, :organization, index: true
      end
    end
  end
end
