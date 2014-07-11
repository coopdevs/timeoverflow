require 'textacular/searchable'

class User < ActiveRecord::Base

  devise *[
    :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :confirmable,
    :lockable,
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

  # Gravatar helpers
  # froom http://railscasts.com/episodes/244-gravatar?language=en&view=asciicast
  def avatar_url(size=32)
    gravatar_id = gravatar_digest
    gravatar_options = Hash[s: size, d: 'identicon']
    "http://gravatar.com/avatar/#{gravatar_id}.png?#{Rack::Utils.build_query(gravatar_options)}"
  end

  def gravatar_link
    "http://es.gravatar.com/site/check/#{gravatar_email}"
  end

  def gravatar_digest
    gravatar_id = Digest::MD5::hexdigest gravatar_email.downcase
    gravatar_id
  end

  def gravatar_email
    attributes['gravatar_email'].blank? ? email : attributes['gravatar_email']
  end
end
