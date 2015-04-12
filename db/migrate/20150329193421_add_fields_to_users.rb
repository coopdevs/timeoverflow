class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :locale, :string, default: I18n.default_locale
    add_column :users, :notifications, :boolean, default: true
  end
end
