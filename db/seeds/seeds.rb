# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside
# the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'faker'
Manager.create!(
                  pesel: '95232822947',
                  first_name: 'Prezes',
                  last_name: "Łukasz",
                  date_of_birth: '1967-01-11',
                  email: 'prezes@purespace.pl',
                  password: 'password',
                  salary: '6500.00',
                  hiredate: '2016-04-01'
                )

p "Created #{Manager.count} manager"

Client.create!(
  pesel: Faker::Number.number(11),
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  date_of_birth: Faker::Time.between('1970-01-01', '2000-12-31'),
  email: 'client@gmail.com',
  password: 'password'
)
p "Created #{Client.count} client for testing"

50.times do
  Client.create!(
    pesel: Faker::Number.number(11),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    date_of_birth: Faker::Time.between('1970-01-01', '2000-12-31'),
    email: Faker::Internet.email,
    password: Faker::Internet.password
  )
end
p "Created #{Client.count} clients"

Receptionist.create!(
  pesel: Faker::Number.number(11),
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  date_of_birth: Faker::Time.between('1970-01-01', '2000-12-31'),
  email: 'receptionist@gmail.com',
  password: 'password',
  salary: Faker::Number.decimal(4, 2),
  hiredate: Faker::Time.between('2016-01-01', '2016-04-30')
)
p "Created #{Receptionist.count} receptionist for testing"

20.times do
  Receptionist.create!(
    pesel: Faker::Number.number(11),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    date_of_birth: Faker::Time.between('1970-01-01', '2000-12-31'),
    email: Faker::Internet.email,
    password: Faker::Internet.password,
    salary: Faker::Number.decimal(4, 2),
    hiredate: Faker::Time.between('2016-01-01', '2016-04-30')
  )
end

p "Created #{Receptionist.count} receptionists"

Lifeguard.create!(
  pesel: Faker::Number.number(11),
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  date_of_birth: Faker::Time.between('1970-01-01', '2000-12-31'),
  email: 'lifeguard@gmail.com',
  password: 'password',
  salary: Faker::Number.decimal(4, 2),
  hiredate: Faker::Time.between('2016-01-01', '2016-04-30')
)
p "Created #{Lifeguard.count} lifeguard for testing"

20.times do
  Lifeguard.create!(
    pesel: Faker::Number.number(11),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    date_of_birth: Faker::Time.between('1970-01-01', '2000-12-31'),
    email: Faker::Internet.email,
    password: Faker::Internet.password,
    salary: Faker::Number.decimal(4, 2),
    hiredate: Faker::Time.between('2016-01-01', '2016-04-30')
  )
end
p "Created #{Lifeguard.count} lifeguards"

  Trainer.create!(
    pesel: Faker::Number.number(11),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    date_of_birth: Faker::Time.between('1970-01-01', '2000-12-31'),
    email: 'trainer@gmail.com',
    password: 'password',
    salary: Faker::Number.decimal(4, 2),
    hiredate: Faker::Time.between('2016-01-01', '2016-04-30')
  )
p "Created #{Trainer.count} trainer for testing"

20.times do
  Trainer.create!(
    pesel: Faker::Number.number(11),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    date_of_birth: Faker::Time.between('1970-01-01', '2000-12-31'),
    email: Faker::Internet.email,
    password: Faker::Internet.password,
    salary: Faker::Number.decimal(4, 2),
    hiredate: Faker::Time.between('2016-01-01', '2016-04-30')
  )
end
p "Created #{Trainer.count} trainers"
