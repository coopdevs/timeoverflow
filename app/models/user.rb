class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_readonly :email
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  def admin?
    username == "admin"
  end

  def name
    "#{username} <#{email}>"
  end


  attr_accessible :email, :username, :date_of_birth, :address, :phone, :alt_phone, :identity_document, as: :admin
  # has_secure_password
  # validates_presence_of :password, :on => :create
  belongs_to :organization
  acts_as_tenant :organization
  attr_accessible :organization_id, as: :admin

  rails_admin do
    #   # Found associations:

    #     configure :organization, :belongs_to_association

    #   # Found columns:

    #     configure :id, :integer
    #     configure :username, :string
    #     configure :email, :string
    #     configure :date_of_birth, :date
    # configure :phone, :string
    # configure :alt_phone, :string
    # configure :address, :text
    #     configure :identity_document, :string
    #     configure :member_code, :string
    #     configure :organization_id, :integer         # Hidden
    #     configure :extra_data, :serialized
    #     configure :created_at, :datetime
    #     configure :updated_at, :datetime
    #     configure :password, :password         # Hidden
    #     configure :password_confirmation, :password         # Hidden
    #     configure :reset_password_token, :string         # Hidden
    #     configure :reset_password_sent_at, :datetime
    #     configure :remember_created_at, :datetime
    #     configure :sign_in_count, :integer
    #     configure :current_sign_in_at, :datetime
    #     configure :last_sign_in_at, :datetime
    #     configure :current_sign_in_ip, :string
    #     configure :last_sign_in_ip, :string

    #   # Cross-section configuration:

    #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
    #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
    #     # label_plural 'My models'      # Same, plural
    #     # weight 0                      # Navigation priority. Bigger is higher.
    #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
    #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

    #   # Section specific configuration:

    #     list do
    #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
    #       # items_per_page 100    # Override default_items_per_page
    #       # sort_by :id           # Sort column (default is primary key)
    #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
    #     end
    show do
      field :organization
      field :username
      field :email
      field :date_of_birth
    end
    edit do
      field :organization do
        visible false
      end
      field :username
      field :email do
        visible false
      end
      field :date_of_birth
      field :identity_document
      field :phone
      field :alt_phone
      field :address
    end
    create do
      configure :organization do
        visible do
          bindings[:view]._current_user.admin? rescue false
        end
      end
      configure :email do
        visible true
      end
    end
    #     export do; end
    #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
    #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
    #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  end rescue nil

end
