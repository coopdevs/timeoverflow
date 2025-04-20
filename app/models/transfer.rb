# A time transfer between accounts.
#
# When an amount of time is to be transferred between two accounts, a
# Transfer object should be created with the following attributes:
#
# source: id or instance of the source account
# destination: id or instance of the destination account
# amount: integer amount of time to transfer
#
# Along with the transfer, two movements are created, one in each related
# account, so the total sum of the system is zero
#
class Transfer < ApplicationRecord
  attr_accessor :source, :destination, :amount, :hours, :minutes, :is_cross_bank, :meta

  belongs_to :post, optional: true
  has_many :movements, dependent: :destroy
  has_many :events, dependent: :destroy

  validates :amount, numericality: { greater_than: 0 }
  validate :different_source_and_destination
  validate :validate_organizations_alliance, if: -> { is_cross_bank && meta.present? }

  after_create :make_movements

  def make_movements
    if is_cross_bank && meta.present?
      make_cross_bank_movements
    else
      movements.create(account: Account.find(source_id), amount: -amount.to_i, created_at: created_at)
      movements.create(account: Account.find(destination_id), amount: amount.to_i, created_at: created_at)
    end
  end

  def make_cross_bank_movements
    source_organization_id = meta[:source_organization_id]
    destination_organization_id = meta[:destination_organization_id]
    final_destination_user_id = meta[:final_destination_user_id]

    source_organization = Organization.find(source_organization_id)
    destination_organization = Organization.find(destination_organization_id)
    final_user = User.find(final_destination_user_id)
    final_member = final_user.members.find_by(organization: destination_organization)

    movements.create(account: Account.find(source_id), amount: -amount.to_i, created_at: created_at)
    movements.create(account: source_organization.account, amount: amount.to_i, created_at: created_at)

    movements.create(account: source_organization.account, amount: -amount.to_i, created_at: created_at)
    movements.create(account: destination_organization.account, amount: amount.to_i, created_at: created_at)

    movements.create(account: destination_organization.account, amount: -amount.to_i, created_at: created_at)
    movements.create(account: final_member.account, amount: amount.to_i, created_at: created_at)
  end

  def source_id
    source.respond_to?(:id) ? source.id : source
  end

  def destination_id
    destination.respond_to?(:id) ? destination.id : destination
  end

  def different_source_and_destination
    return unless source == destination
    errors.add(:base, :same_account)
  end

  def cross_bank?
    movements.count > 2
  end

  def related_account_for(movement)
    return nil unless movement.transfer == self

    movements_in_order = movements.order(:id)
    current_index = movements_in_order.index(movement)
    return nil unless current_index

    if movement.amount > 0 && current_index > 0
      movements_in_order[current_index - 1].account
    elsif movement.amount < 0 && current_index < movements_in_order.length - 1
      movements_in_order[current_index + 1].account
    end
  end

  private

  def validate_organizations_alliance
    return unless meta[:source_organization_id] && meta[:destination_organization_id]

    source_org = Organization.find_by(id: meta[:source_organization_id])
    dest_org = Organization.find_by(id: meta[:destination_organization_id])

    return unless source_org && dest_org

    alliance = source_org.alliance_with(dest_org)

    unless alliance && alliance.accepted?
      errors.add(:base, :no_alliance_between_organizations)
    end
  end
end
