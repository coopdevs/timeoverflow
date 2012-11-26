class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_secure_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  has_many :categories

  # Setup accessible (or protected) attributes for your model
  def admin?
    username == "admin"
  end

  def name
    "#{username} <#{email}>"
  end

  belongs_to :organization
  acts_as_tenant :organization

end
