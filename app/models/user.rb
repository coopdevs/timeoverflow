class User < ApplicationRecord
  devise *[
    :database_authenticatable,
    :recoverable,
    :rememberable,
    :confirmable,
    :lockable,
    :trackable,
    :timeoutable
  ]

  ransacker :username do
    Arel.sql('unaccent(users.username)')
  end

  GENDERS = %w(
    female
    male
    others
    prefer_not_to_answer
  )

  attr_accessor :empty_email
  attr_accessor :from_signup

  has_one_attached :avatar

  has_many :members, dependent: :destroy
  has_many :organizations, through: :members
  has_many :accounts, through: :members
  has_many :movements, through: :accounts
  has_many :posts
  has_many :offers
  has_many :inquiries
  has_many :device_tokens
  has_many :petitions, dependent: :delete_all

  accepts_nested_attributes_for :members, allow_destroy: true

  default_scope { order("users.id ASC") }
  scope :without_memberships, -> { where.missing(:members) }
  scope :actives, -> { joins(:members).where(members: { active: true }) }
  scope :online_active, -> { where("sign_in_count > 0") }
  scope :notifications, -> { where(notifications: true) }
  scope :confirmed, -> { where.not(confirmed_at: nil) }

  validates :username, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, if: :from_signup?
  # Allows @domain.com for dummy emails but does not allow pure invalid
  # emails like 'without email'
  validates_format_of :email,
                      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :gender, inclusion: { in: GENDERS, allow_blank: true }

  def as_member_of(organization)
    organization && members.find_by(organization: organization)
  end

  def admins?(organization)
    organization && !!(as_member_of(organization).try :manager)
  end
  alias :manages? :admins?

  def superadmin?
    ADMINS.include? email
  end
  alias :superuser? :superadmin?

  def to_s
    "#{username}"
  end

  def user
    self
  end

  def add_to_organization(organization)
    return unless organization

    member = members.where(organization: organization).first_or_initialize

    return member if member.persisted?

    member.entry_date = DateTime.now.utc

    persister = ::Persister::MemberPersister.new(member)
    persister.save

    return member if member.persisted?
  end

  def active?(organization)
    organization && !!(as_member_of(organization).try :active)
  end

  def member(organization)
    members.where(organization_id: organization).first
  end

  def set_dummy_email
    self.email = "user#{id}@example.com"
    skip_reconfirmation! # auto-reconfirm
  end

  def setup_and_save_user
    # check if email is provided or not. If not, flag it and generate
    # temporary valid email with current time milliseconds
    # this will be updated to user.id@example.com later on
    self.empty_email = email.strip.empty?
    self.email = "user#{DateTime.now.strftime('%Q')}@example.com" if empty_email && !from_signup
    skip_confirmation! unless from_signup?
    save
  end

  def tune_after_persisted(organization)
    add_to_organization organization

    # If email was empty, udpate again with user.id just generated
    set_dummy_email if empty_email
    save
  end

  def add_tags(organization, tag_list)
    member = as_member_of(organization)
    member.update(tag_list: tag_list)
  end

  def has_valid_email?
    !email.include? "example.com"
  end

  def email_if_real
    has_valid_email? ? email : ""
  end

  def was_member?(petition)
    petition.status == 'accepted' && Member.where(organization: petition.organization, user: self).none?
  end

  def from_signup?
    from_signup
  end
end
