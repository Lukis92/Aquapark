# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside
# the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Manager.create!([{
                  pesel: '95232822947',
                  first_name: 'Prezes',
                  last_name: "Łukasz",
                  date_of_birth: '1967-01-11',
                  email: 'prezes@purespace.pl',
                  password: 'password'
                }])

p "Created #{Manager.count} managers"

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
