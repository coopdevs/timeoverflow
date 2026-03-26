class Category < ApplicationRecord
  has_many :posts

  translates :name

  def display_name
    return name if name.present?

    fallback_locale, fallback_name = name_translations&.find { |_, v| v.present? }
    return "#{fallback_name} [#{fallback_locale}]" if fallback_name.present?

    self.class.model_name.human
  end

  def to_s
    display_name
  end
end
