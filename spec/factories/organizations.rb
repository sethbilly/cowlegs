require 'faker'

FactoryGirl.define do 
	factory :organization do
		name {Faker::Name.name}
		description {Faker::Lorem.sentence}
		postal_address {Faker::Address.postcode}
		number_of_staff {Faker::Number.digit}
		region {Faker::Address.state}
		district {Faker::Address.city}
	end
end