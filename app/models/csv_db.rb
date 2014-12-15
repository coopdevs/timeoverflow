require "csv"

class CsvDb
  class << self
    def user_from_row(row)
      User.new(username: row[2..4].join(" "), date_of_birth: row[6],
               email: row[9], phone: row[7], alt_phone: row[8],
               gender: User::GENDERS[row[5].to_i - 1])
    end

    def member_from_row(row, user, organization, errors)
      member = organization.members.create(member_uid: row[0],
                                           entry_date: row[1],
                                           user_id: user.id)
      errors.push(member_id: row[0], email: row[9],
                  errors: member.errors.full_messages
                 ) if member.errors.present?
    end

    def process_row(row, organization, errors)
      user = user_from_row(row)
      user.skip_confirmation! # auto-confirm, not sending confirmation email

      if user.save
        member_from_row(row, user, organization, errors)
      else
        errors.push(member_id: row[0], email: row[9],
                    errors: user.errors.full_messages)
      end
    end

    def convert_save(organization_id, csv_data)
      data = csv_data.read
      # data.force_encoding Encoding::ISO_8859_1
      # normalized_data = data.encode(Encoding::UTF_8)[1..-1]
      organization = Organization.find(organization_id)
      errors = []
      CSV.parse(data, headers: false) do |row|
        process_row(row, organization, errors)
      end
      organization.ensure_reg_number_seq!
      errors
    end
  end
end
