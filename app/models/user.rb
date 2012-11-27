class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_secure_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  has_and_belongs_to_many :categories

  def admin?
    username == "admin"
  end

  belongs_to :organization

end
