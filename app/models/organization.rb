class Organization < ActiveRecord::Base
  before_validation :ensure_url
  validates_uniqueness_of :name
  has_many :members, dependent: :destroy
  has_many :users, -> { order "members.created_at DESC" }, through: :members

  has_one :account, as: :accountable
  after_create :create_account

  has_many :member_accounts, through: :members, source: :account

  has_many :posts
  has_many :offers
  has_many :inquiries

  has_many :documents, as: :documentable

  BOOTSWATCH_THEMES = %w[amelia cerulean cosmo cyborg flatly journal readable
                         simplex slate spacelab united]
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

  def ensure_url
    URI.parse(web)
    rescue
      errors.add(:web, :url_format_invalid)
  else
    return if (web.blank?) || (URI.parse(web).is_a? URI::HTTP)
    if URI.parse("http://#{web}").is_a? URI::HTTP
      self.web = "http://#{web}"
    else
      errors.add(:web, :url_format_invalid)
    end
  end

end
