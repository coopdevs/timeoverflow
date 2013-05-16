class Transfer < ActiveRecord::Base
	has_one :inbound_movement
	has_one :outbound_movement

	delegate :from_user, to: :outbound_movement, field: :user
	delegate :to_user, to: :inbound_movement, field: :user

	belongs_to :agent, class_name: "User", column: "user_id"
	belongs_to :category
  attr_accessible :amount, :category_id, :date, :user_id
end
