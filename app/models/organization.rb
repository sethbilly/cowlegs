class Organization < ApplicationRecord
	validates :name, :region, :district, :postal_address, :number_of_staff, presence: true
	has_many :user_organizations
	has_many :users, through: :user_organizations, dependent: :destroy
	has_many :organization_farmers
	has_many :farmers, through: :organization_farmers, dependent: :destroy
end
