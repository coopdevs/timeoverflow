class Organization < ActiveRecord::Base
  validates_uniqueness_of :name
  has_many :members
  has_many :users, through: :members

  has_one :account, as: :accountable
  after_create :create_account

  has_many :member_accounts, through: :members, source: :account

  has_many :offers, through: :users
  has_many :inquiries, through: :users

  has_many :documents, as: :documentable

  BOOTSWATCH_THEMES = %w[amelia cerulean cosmo cyborg flatly journal readable simplex slate spacelab united]
  # validates :theme, allow_nil: true, inclusion: {in: BOOTSWATCH_THEMES}

  scope :matching, ->(str) {
    where(Organization.arel_table[:name].matches("%#{str}%"))
  }

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

end
