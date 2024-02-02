# Used in the Admin section to import users and members
# to a specific organization, from a CSV file.

require "csv"

class UserImporter
  Row = Struct.new(
    :username,
    :member_id,
    :entry_date,
    :date_of_birth,
    :email,
    :phone,
    :alt_phone,
    :gender
  ) do
    def user_from_row
      User.new(
        username: username,
        date_of_birth: date_of_birth,
        email: email,
        phone: phone,
        alt_phone: alt_phone,
        gender: gender,
        locale: I18n.locale
      )
    end
  end

  class << self
    def call(organization_id, csv_data)
      data = csv_data.read
      organization = Organization.find(organization_id)
      errors = []

      CSV.parse(data, headers: false) do |data_row|
        row = Row.new(
          data_row[2..4].join(" "),
          data_row[0],
          data_row[1],
          data_row[6],
          data_row[9],
          data_row[7],
          data_row[8],
          User::GENDERS[data_row[5].to_i - 1]
        )
        process_row(row, organization, errors)
      end

      organization.ensure_reg_number_seq!
      errors
    end

    def process_row(row, organization, errors)
      user = row.user_from_row
      user.skip_confirmation! # auto-confirm, not sending confirmation email

      if user.save
        member_from_row(row, user, organization, errors)
      else
        errors.push(member_id: row.member_id, email: row.email,
                    errors: user.errors.full_messages)
      end
    end

    def member_from_row(row, user, organization, errors)
      member = organization.members.create(member_uid: row.member_id,
                                           entry_date: row.entry_date,
                                           user_id: user.id)

      if member.errors.present?
        errors.push(member_id: row.member_id, email: row.email,
                    errors: member.errors.full_messages)
      end
    end
  end
end
