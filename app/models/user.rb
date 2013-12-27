require 'persona'

class User < ActiveRecord::Base

  GENDERS = %w[male female]

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :gender, presence: true, inclusion: {in: GENDERS}

  has_many :members
  accepts_nested_attributes_for :members
  has_many :organizations, through: :members
  has_many :accounts, through: :members
  has_many :movements, through: :accounts

  has_many :posts
  has_many :offers
  has_many :inquiries

  def self.authenticate_with_persona(assertion)
    Persona.authenticate(assertion)
  end

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
end
