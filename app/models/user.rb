require 'textacular/searchable'

class User < ActiveRecord::Base

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

  default_scope ->{ order('users.id ASC') }

  scope :actives, -> { where({ members: { active: true } }) }

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  # validates :gender, presence: true, inclusion: {in: GENDERS}

  has_many :members
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

  def add_to_organization organization
    organization && members.find_or_create_by(organization: organization) do |member|
      member.entry_date = DateTime.now.utc
    end
  end

  def active?(organization)
    organization && !!(as_member_of(organization).try :active)
  end

  def member(organization)
    members.where(organization_id: organization).first
  end
end
