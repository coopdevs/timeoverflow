# Used in the Admin section to import users and members
# to a specific organization, from a CSV file.

require "csv"

class PostImporter
  Row = Struct.new(
    :user_id,
    :type,
    :title,
    :description,
    :category_id,
    :created_at,
    :start_on,
    :end_on
  ) do
    def post_from_row
      Object.const_get(type).new(
        user_id: user_id,
        title: title,
        description: description,
        category_id: category_id,
        created_at: created_at,
        start_on: start_on,
        end_on: end_on
      )
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
      post = row.post_from_row
      post.organization_id = organization_id
      return if post.save

      errors.push(user_id: row.user_id, title: row.title, errors: post.errors.full_messages)
    end
  end
end
