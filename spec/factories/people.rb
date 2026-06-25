require 'faker'

FactoryBot.define do
  factory :person do
    pesel { Faker::Number.number(digits: 11).to_s }
    first_name { 'Thomas' }
    last_name { 'Owel' }
    date_of_birth { Faker::Time.between(from: '1970-01-01', to: '2000-12-31') }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    type { 'Person' }
  end

  factory :client, parent: :person, class: 'Client' do
    pesel { Faker::Number.number(digits: 11).to_s }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    type { 'Client' }
  end

  factory :client1, parent: :person, class: 'Client' do
    pesel { Faker::Number.number(digits: 11).to_s }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    type { 'Client' }
  end

  factory :trainer, parent: :person, class: 'Trainer' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    type { 'Trainer' }
    salary { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    hiredate { Faker::Time.between(from: '2016-01-01', to: '2016-04-30') }
  end

  factory :trainer1, parent: :person, class: 'Trainer' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    type { 'Trainer' }
    salary { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    hiredate { Faker::Time.between(from: '2016-01-01', to: '2016-04-30') }
  end

  factory :receptionist, parent: :person, class: 'Receptionist' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    type { 'Receptionist' }
    salary { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    hiredate { Faker::Time.between(from: '2016-01-01', to: '2016-04-30') }
  end

  factory :lifeguard, parent: :person, class: 'Lifeguard' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    type { 'Lifeguard' }
    salary { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    hiredate { Faker::Time.between(from: '2016-01-01', to: '2016-04-30') }
  end
end
