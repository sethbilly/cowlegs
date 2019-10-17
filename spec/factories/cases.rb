require 'faker'

FactoryGirl.define do 
	factory :active_case do
		community 'Jamestown'
		pictures ['http://s3.images.com']
		location { { address: 'James Town', lat: '323323', lng: '232332' } }
		species {Faker::Name.name}
		type_of_case 'active'
		age {Faker::Number.digit}
		sex 'Female'
		number_dead {Faker::Number.digit}
		number_at_risk {Faker::Number.digit}
		number_examined {Faker::Number.digit}
		measures_adopted 'Vaccination'
	end
end