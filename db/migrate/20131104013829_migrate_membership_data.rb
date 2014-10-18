class MigrateMembershipData < ActiveRecord::Migration

  class User < ActiveRecord::Base
    has_one :account, as: :accountable
    has_many :members
  end

  class Member < ActiveRecord::Base
    belongs_to :user
    has_one :account, as: :accountable
  end

  class Account < ActiveRecord::Base
    belongs_to :accountable, polymorphic: true
  end

  def up
    User.transaction do
      User.all.each do |u|
        member = u.members.create(
          organization_id: u.organization_id,
          manager: u.admin,
          entry_date: u.registration_date,
          member_uid: u.registration_number
        )
        account = u.account || Account.new
        account.accountable = member
        account.save
      end
      Account.where(accountable_type: "MigrateMembershipData::Member").
        update_all(accountable_type: "Member")
    end
  end
end
