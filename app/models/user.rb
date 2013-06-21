class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  acts_as_paranoid
  has_secure_password

  attr_readonly :registration_number

  validates :email, presence: true, uniqueness: true
  validates :password, on: :create, presence: true, confirmation: true
  validates :gender, presence: true, inclusion: {:in => %w[male female]}
  validates :organization_id, presence: true, :unless => :superadmin?
  validates :identity_document, presence: true, uniqueness: {scope: :organization_id}
  validates :registration_number, uniqueness: { scope: :organization_id }

  before_create :assign_registration_number

  has_and_belongs_to_many :joined_posts,
    class_name: "Post",
    join_table: "user_joined_post",
    foreign_key: "user_id",
    association_foreign_key: "post_id"

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
