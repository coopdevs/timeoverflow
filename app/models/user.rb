require 'persona'

class User < ActiveRecord::Base

  acts_as_paranoid
  acts_as_taggable_on :skills, :needs rescue nil
   # HACK: there is a known issue that acts_as_taggable breaks asset precompilation on Heroku.

  attr_readonly :registration_number

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :gender, presence: true, inclusion: {:in => %w[male female]}
  validates :organization_id, presence: true
  validates :identity_document, presence: true, uniqueness: { scope: :organization_id }
  validates :registration_number, uniqueness: { scope: :organization_id }

  before_create :assign_registration_number

  has_one :account, as: :accountable
  after_create :create_account

  has_many :posts
  has_many :offers
  has_many :inquiries

  has_and_belongs_to_many :joined_posts,
    class_name: "Post",
    join_table: "user_joined_post",
    foreign_key: "user_id",
    association_foreign_key: "post_id" do
      def offers
        where type: "Offer"
      end
      def inquiries
        where type: "Inquiry"
      end
    end


  def self.authenticate_with_persona(assertion)
    Persona.authenticate(assertion)
  end

  def assign_registration_number
    self.registration_number ||= organization.next_reg_number_seq
  end

  def admin?
    admin or superadmin
  end

  def admins?(organization)
    superadmin? || (admin? && organization == self.organization)
  end

  def superadmin?
    superadmin
  end

  belongs_to :organization

  def to_s
    "#{registration_number} - #{username}"
  end
end
