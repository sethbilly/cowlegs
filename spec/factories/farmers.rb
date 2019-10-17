require 'faker'

FactoryGirl.define do 
	factory :farmer do
		first_name {Faker::Name.first_name}
		last_name {Faker::Name.last_name}
		phone_number {Faker::PhoneNumber.cell_phone}
		sex 'M'
		age {Faker::Number.digit}
		level_of_education {Faker::Lorem.characters(10)}
		region {Faker::Lorem.characters(10)}
		district {Faker::Lorem.characters(10)}
		community {Faker::Lorem.characters(10)}
		household_name {Faker::Lorem.characters(10)}
		house_id {Faker::Lorem.characters(10)}
		farm_name {Faker::Lorem.characters(10)}
		farm_location {Faker::Lorem.characters(10)}
		livestock_keeping_reason {Faker::Lorem.sentence }
		years_since_farm_started {Faker::Lorem.characters(10)}
		source_of_feeding {Faker::Lorem.characters(10)}
		production_challenges {[Faker::Lorem.characters(10)]}
		action_taken_when_animal_is_sick {Faker::Lorem.sentence }
		action_taken_when_animal_care_info_is_needed {Faker::Lorem.sentence }
		how_disease_outbreak_is_known {Faker::Lorem.sentence}
		action_taken_when_disease_outbreak {Faker::Lorem.sentence}
		service_subscription {[Faker::Lorem.characters(10)]}
		location { { address: 'James Town', lat: '323323', lng: '232332' } }
		picture {Faker::Internet.url}
	end
end