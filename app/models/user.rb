class User < ApplicationRecord
  extend FriendlyId
  friendly_id :first_name, use: :slugged
  
  include Swagger::Blocks
  include Filterable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, password_length: 6..128

  # the following will allow args to be passed to send_reset_password_instructions
  include DeviseTokenAuth::Concerns::User

  validates :first_name, presence: true
  validates :phone_number, presence: true, uniqueness: true

  belongs_to :zone, optional: true
  has_many :animal_tag_vaccinations
  has_many :subscriptions
  has_many :user_payments
  has_many :payments, -> { order(created_at: :desc) }, through: :user_payments, dependent: :destroy
  has_many :commissions, -> { order(created_at: :desc) }
  has_many :user_organizations
  has_many :organizations, through: :user_organizations, dependent: :destroy
  has_many :cases, dependent: :destroy
  has_many :user_farmers
  # ideally we shouldn't use a join table and a farmer should just belong to a user
  # however, users can be deleted from the platform 
  # and we don't want to have orphaned farmers 
  # who we don't want to delete when a user is deleted
  has_many :farmers, through: :user_farmers, dependent: :destroy
  has_many :provider_campaigns
  has_many :campaigns, through: :provider_campaigns, dependent: :destroy

  enum role: [:agent, :provider, :manager, :admin, :partner]

  scope :with_role, -> (role) { where role: role }
  scope :with_two_roles, ->(roles) { with_role(roles[0]).or(with_role(roles[1])) }
  scope :with_term, -> (term) { where(
    'first_name ILIKE ? '\
    'OR last_name ILIKE ? '\
    'OR email LIKE ? '\
    'OR phone_number LIKE ?', "%#{term}%", "%#{term}%", "%#{term}%", "%#{term}%"
  )}

  def create_new_jwt_token
    JWTWrapper.encode(user_id: self.id)
  end

  def is_admin?
    self.role == 'admin'
  end

  def is_manager?
    self.role == 'manager'
  end

  def is_partner?
    self.role == 'partner'
  end

  def is_provider?
    self.role == 'provider'
  end

  swagger_schema :UserResponse do
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :email do
      key :type, :string
    end
    property :first_name do
      key :type, :string
    end
    property :last_name do
      key :type, :string
    end
    property :phone_number do
      key :type, :string
    end
    property :role do
      key :type, :string
    end
    property :date_of_birth do
      key :type, :string
      key :format, :date
    end
    property :picture do
      key :type, :string
    end
    property :gender do
      key :type, :string
    end
    property :updated_at do
      key :type, :string
      key :format, :date
    end
    property :organizations do
      key :type, :array
      items do
        key :'$ref', :Organization
      end
    end
  end

  swagger_schema :Organization do
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :name do
      key :type, :string
    end
    property :postal_address do
      key :type, :string
    end
    property :description do
      key :type, :string
    end
    property :region do
      key :type, :string
    end
    property :district do
      key :type, :string
    end
    property :number_of_staff do
      key :type, :integer
      key :format, :int64
    end
  end

  swagger_schema :SignInUserInput do
    allOf do
      schema do
        key :required, [:email, :username, :password]
        property :data do
          key :type, :object
          property :email do
            key :type, :string
            key :description, 'Email of user'
          end
          property :username do
            key :type, :string
            key :description, 'Username of user'
          end
          property :password do
            key :type, :string
          end
        end
      end
    end
  end

  swagger_schema :SignUpUserInput do
    allOf do
      schema do
        key :required, [:email, :password, :phone_number]
        property :user do
          key :type, :object
          property :email do
            key :type, :string
          end
          property :username do
            key :type, :string
          end
          property :password do
            key :type, :string
          end
          property :phone_number do
            key :type, :string
          end
          property :first_name do
            key :type, :string
          end
          property :last_name do
            key :type, :string
          end
          property :role do
            key :type, :string
          end
          property :organization do
            key :type, :object
            key :'$ref', :Organization
            key :description, 'Organization of user. This is mostly for managers and partners to add other users to this organization'
          end
        end
      end
    end
  end

  swagger_schema :UserDataResponse do
    property :success do
      key :type, :boolean
    end
    property :data do
      key :type, :object
      key :'$ref', :UserResponse
    end
  end

  swagger_schema :SuccessResponse do
    property :success do
      key :type, :boolean
    end
  end

  swagger_schema :SendPasswordResetEmail do
    property :success do
      key :type, :boolean
    end
    property :message do
      key :type, :string
    end
  end

  swagger_schema :UpdateUserInput do
    allOf do
      schema do
        property :user do
          key :type, :object
          property :email do
            key :type, :string
          end
          property :first_name do
            key :type, :string
          end
          property :last_name do
            key :type, :string
          end
          property :phone_number do
            key :type, :string
          end
          property :date_of_birth do
            key :type, :string
            key :format, :date
          end
          property :picture do
            key :type, :string
          end
          property :gender do
            key :type, :string
          end
        end
      end
    end
  end

end
