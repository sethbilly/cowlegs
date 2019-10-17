require 'faker'

FactoryGirl.define do 
	factory :species do
		name {Faker::Name.name}
	end
end