# Used in the Admin section to import transfers
# to a specific organization, from a CSV file.

require "csv"

class TransferImporter
  Row = Struct.new(
    :source_id,
    :source_type,
    :destination_id,
    :destination_type,
    :amount,
    :created_at,
    :reason,
    :post_id
  ) do
    def transfer_from_row(organization_id, errors)
      source = find_account(source_id, source_type, organization_id, errors, 'source')
      destination = find_account(destination_id, destination_type, organization_id, errors, 'destination')
      return unless source && destination

      Transfer.new(
        source: source,
        destination: destination,
        amount: amount,
        created_at: created_at,
        reason: reason,
        post_id: post_id,
      )
    end

    private

    def find_account(id, type, organization_id, errors, direction)
      acc = if type.downcase == 'organization'
              Organization.find(organization_id).account
            else
              Member.find_by(member_uid: id, organization_id: organization_id)&.account
            end

      unless acc
        errors.push(account_id: id, errors: "#{direction}_id #{id} not found in organization #{organization_id}")
        return false
      end
      acc
    end
  end

  class << self
    def call(organization_id, csv_data)
      data = csv_data.read
      errors = []

      CSV.parse(data, headers: false) do |data_row|
        row = Row.new(
          data_row[0],
          data_row[1],
          data_row[2],
          data_row[3],
          data_row[4],
          data_row[5],
          data_row[6],
          data_row[7]
        )
        process_row(row, organization_id, errors)
      end

      errors
    end

    def process_row(row, organization_id, errors)
      transfer = row.transfer_from_row(organization_id, errors)
      return if !transfer || transfer.save

      errors.push(account_id: row.source_id, errors: transfer.errors.full_messages)
    end
  end
end
