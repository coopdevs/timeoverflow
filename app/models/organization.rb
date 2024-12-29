class Organization < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search_by_query,
    against: %i[city neighborhood address name],
    ignoring: :accents,
    using: {
      tsearch: {
        prefix: true
      }
    }

  has_one_attached :logo

  has_many :members, dependent: :destroy
  has_many :users, -> { order "members.created_at DESC" }, through: :members
  has_many :all_accounts, class_name: "Account", inverse_of: :organization, dependent: :destroy
  has_many :all_movements, class_name: "Movement", through: :all_accounts, source: :movements
  has_many :all_transfers, class_name: "Transfer", through: :all_movements, source: :transfer
  has_one :account, as: :accountable, dependent: :destroy
  has_many :member_accounts, through: :members, source: :account
  has_many :posts, dependent: :destroy
  has_many :offers
  has_many :inquiries
  has_many :documents, as: :documentable, dependent: :destroy
  has_many :petitions, dependent: :delete_all

  validates :name, presence: true, uniqueness: true

  LOGO_CONTENT_TYPES = %w(image/jpeg image/png image/gif)
  validates :logo, content_type: LOGO_CONTENT_TYPES

  before_validation :ensure_url
  after_create :create_account

  def to_s
    "#{name}"
  end

  def all_transfers_with_accounts
    all_transfers.
      includes(movements: { account: :accountable }).
      order("transfers.created_at DESC").
      distinct
  end

  def all_managers
    users.where(members: { manager: true })
  end

  def display_name_with_uid
    self
  end

  # Returns the id to be displayed in the :new transfer page with the given
  # destination_accountable
  #
  # @params destination_accountable [Organization | Object] target of a transfer
  # @return [Integer | String]
  def display_id
    account.accountable_id
  end

  def ensure_reg_number_seq!
    update_column(:reg_number_seq, members.maximum(:member_uid))
  end

  def ensure_reg_number_seq
    ensure_reg_number_seq! unless reg_number_seq
  end

  def next_reg_number_seq
    ensure_reg_number_seq
    increment!(:reg_number_seq)
    reg_number_seq
  end

  def ensure_url
    return if web.blank? || URI.parse(web).is_a?(URI::HTTP)
  rescue
    errors.add(:web, :url_format_invalid)
  else
    if URI.parse("http://#{web}").is_a?(URI::HTTP)
      self.web = "http://#{web}"
    else
      errors.add(:web, :url_format_invalid)
    end
  end
end
