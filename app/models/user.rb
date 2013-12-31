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


  def admins?(organization)
    members.where(organization: organization, manager: true).exists?
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
    unless members.where(organization: organization).exists?
      member = members.create(organization: organization) do |member|
        member.entry_date = DateTime.now.utc
      end
    end
    member
  end
end
