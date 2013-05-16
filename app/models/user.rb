class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  acts_as_paranoid
  has_secure_password


  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  attr_readonly :registration_number

  validates :registration_number, :uniqueness => { :scope => :organization_id }

  has_and_belongs_to_many :categories

  has_many :tranfers
  has_many :categories, :through => :transfer
  
  attr_accessible :username

  before_create :assign_registration_number

  def assign_registration_number
    self.registration_number ||= begin
      unless organization.reg_number_seq
        organization.update_column(:reg_number_seq, organization.users.with_deleted.maximum(:registration_number))
      end
      organization.increment!(:reg_number_seq)
      organization.reg_number_seq
    end
  end

  def create_fake_password
    [*('a'..'z'),*('0'..'9')].shuffle[0,8].join
  end

  def admin?
    admin or superadmin
  end

  def superadmin?
    superadmin
  end

  belongs_to :organization

  def to_s
    username
  end
end
