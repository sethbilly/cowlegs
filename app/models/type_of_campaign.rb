class TypeOfCampaign < ApplicationRecord
	validates :type_of_campaign, :code, presence: true, uniqueness: true

	has_many :campaigns
	has_many :vaccination_schedules
end
