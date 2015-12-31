class Organization < ActiveRecord::Base
  has_many :members, dependent: :destroy
  has_many :users, -> { order "members.created_at DESC" }, through: :members
  has_many :all_accounts, class_name: "Account", inverse_of: :organization
  has_many :all_movements, class_name: "Movement", through: :all_accounts, source: :movements do
    def with_transfer
      joins(transfer: :movements)
    end
  end
  has_many :all_transfers, class_name: "Transfer", through: :all_movements, source: :transfer
  has_one :account, as: :accountable
  has_many :member_accounts, through: :members, source: :account
  has_many :posts
  has_many :offers
  has_many :inquiries
  has_many :documents, as: :documentable

  scope :matching, ->(str) {
    where(Organization.arel_table[:name].matches("%#{str}%"))
  }

  validates :name, uniqueness: true

  before_validation :ensure_url
  after_create :create_account

  def to_s
    "#{name}"
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
