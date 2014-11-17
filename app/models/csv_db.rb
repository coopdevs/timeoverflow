require 'csv'

class CsvDb
  class << self
    def convert_save(organization_id, csv_data)
      data = csv_data.read
      data.force_encoding Encoding::ISO_8859_1
      normalized_data = data.encode(Encoding::UTF_8)[1..-1]
      organization = Organization.find(organization_id)
      CSV.parse(normalized_data, col_sep: ";", headers: false) do |row|
        user = User.new(username: row[2..4].join(" "), date_of_birth: row[6], email: row[9], phone: row[7], alt_phone: row[8], gender: User::GENDERS[row[5].to_i - 1])
        if user.save
          organization.members.create(member_uid: row[0], entry_date: row[1], user_id: user.id)
          organization.update(reg_number_seq: organization.reg_number_seq + 1)
        else
          # catch errors: user.errors.full_messages
        end
      end
    end
  end
end
