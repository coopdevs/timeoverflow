class User < ActiveRecord::Base

  acts_as_paranoid
  acts_as_taggable_on :skills, :needs rescue nil
   # HACK: there is a known issue that acts_as_taggable breaks asset precompilation on Heroku.

  attr_readonly :registration_number

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
    server = 'https://verifier.login.persona.org/verify'
    assertion_params = {
      assertion: assertion,
      audience: ENV['PERSONA_AUDIENCE'] || 'http://0.0.0.0:3000'
    }
    request = RestClient::Resource.new(server, verify_ssl: true).post(assertion_params)
    response = JSON.parse(request)

    if response['status'] == 'okay'
      return response
    else
      ap response
      return {status: 'error'}.to_json
    end
  end


  def assign_registration_number
    self.registration_number ||= begin
      unless organization.reg_number_seq
        organization.update_column(:reg_number_seq, organization.users.with_deleted.maximum(:registration_number))
      end
      organization.increment!(:reg_number_seq)
      organization.reg_number_seq
    end
  end

  def admin?
    admin or superadmin
  end

  def superadmin?
    superadmin
  end

  belongs_to :organization

  def to_s
    "#{registration_number} - #{username}"
  end
end
