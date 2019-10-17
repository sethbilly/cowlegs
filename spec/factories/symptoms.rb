require 'faker'

FactoryGirl.define do 
	factory :symptom do
		description {Faker::Lorem.sentence}
	end
end