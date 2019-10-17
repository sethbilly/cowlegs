require 'faker'

FactoryGirl.define do 
	factory :disease do
		name {Faker::Name.name}
		description {Faker::Lorem.sentence}
	end
end