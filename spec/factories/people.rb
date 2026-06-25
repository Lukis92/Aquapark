require 'faker'

FactoryBot.define do
  sequence(:valid_pesel) do |n|
    n_mod  = n % 1000
    prefix = "9103010%03d" % n_mod
    digits = prefix.chars.map(&:to_i)
    weights = [1, 3, 7, 9, 1, 3, 7, 9, 1, 3]
    sum   = weights.each_with_index.sum { |w, i| w * digits[i] }
    check = (10 - sum % 10) % 10
    prefix + check.to_s
  end

  factory :person do
    pesel         { generate(:valid_pesel) }
    first_name    { 'Thomas' }
    last_name     { 'Owel' }
    email         { Faker::Internet.email }
    password      { Faker::Internet.password }
    type          { 'Person' }
    date_of_birth { Date.new(1991, 3, 1) }
  end

  factory :client, parent: :person, class: 'Client' do
    pesel         { nil }
    first_name    { Faker::Name.first_name }
    last_name     { Faker::Name.last_name }
    date_of_birth { Faker::Date.between(from: '1970-01-01', to: '2000-12-31') }
    type          { 'Client' }
  end

  factory :client1, parent: :person, class: 'Client' do
    pesel         { nil }
    first_name    { Faker::Name.first_name }
    last_name     { Faker::Name.last_name }
    date_of_birth { Faker::Date.between(from: '1970-01-01', to: '2000-12-31') }
    type          { 'Client' }
  end

  factory :trainer, parent: :person, class: 'Trainer' do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    type       { 'Trainer' }
    salary     { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    hiredate   { Faker::Time.between(from: '2016-01-01', to: '2016-04-30') }
  end

  factory :trainer1, parent: :person, class: 'Trainer' do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    type       { 'Trainer' }
    salary     { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    hiredate   { Faker::Time.between(from: '2016-01-01', to: '2016-04-30') }
  end

  factory :receptionist, parent: :person, class: 'Receptionist' do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    type       { 'Receptionist' }
    salary     { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    hiredate   { Faker::Time.between(from: '2016-01-01', to: '2016-04-30') }
  end

  factory :lifeguard, parent: :person, class: 'Lifeguard' do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    type       { 'Lifeguard' }
    salary     { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    hiredate   { Faker::Time.between(from: '2016-01-01', to: '2016-04-30') }
  end
end
