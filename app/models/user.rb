require "textacular/searchable"

class User < ActiveRecord::Base
  attr_accessor :empty_email

  devise *[
    :database_authenticatable,
    # :registerable,
    :recoverable,
    :rememberable,
    :confirmable,
    :lockable,
    :trackable
  ]

  extend Searchable :username, :email, :phone, :alt_phone

  GENDERS = %w[male female]

  default_scope -> { order("users.id ASC") }

  scope :actives, -> { where(members: { active: true }) }

  validates :username, presence: true
  validates :email, presence: true, uniqueness: true

  # Allows @domain.com for dummy emails but does not allow pure invalid
  # emails like 'without email'
  validates_format_of :email,
                      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  # validates :gender, presence: true, inclusion: {in: GENDERS}

  has_many :members, dependent: :destroy
  accepts_nested_attributes_for :members
  has_many :organizations, through: :members
  has_many :accounts, through: :members
  has_many :movements, through: :accounts

  has_many :posts
  has_many :offers
  has_many :inquiries

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

  def add_to_organization(organization)
    organization && members.
      find_or_create_by(organization: organization) do |member|
      member.entry_date = DateTime.now.utc
    end
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
    self.email = "user#{DateTime.now.strftime('%Q')}@example.com" if empty_email
    skip_confirmation! # auto-confirm, not sending confirmation email
    save
  end

  def tune_after_persisted(organization)
    add_to_organization organization

    # If email was empty, udpate again with user.id just generated
    set_dummy_email if empty_email
    save
  end

  def has_valid_email?
    !email.include? "example.com"
  end
end
