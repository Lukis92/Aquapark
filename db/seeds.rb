# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Client.destroy_all
Receptionist.destroy_all
Lifeguard.destroy_all
Trainer.destroy_all
Manager.destroy_all
WorkSchedule.destroy_all
ActiveRecord::Base.connection.reset_pk_sequence!('people')
ActiveRecord::Base.connection.reset_pk_sequence!('work_schedules')
Manager.create!([{
  pesel: "95232822947",
  first_name: "Prezes",
  last_name: "Łukasz",
  date_of_birth: "1967-01-11",
  email: "prezes@purespace.pl",
  password: "password"
  }])

  p "Created #{Manager.count} managers"

50.times do
  Client.create!(
    pesel: Faker::Number.number(11),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    date_of_birth: Faker::Time.between("1970-01-01", "2000-12-31"),
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
    date_of_birth: Faker::Time.between("1970-01-01", "2000-12-31"),
    email: Faker::Internet.email,
    password: Faker::Internet.password,
    salary: Faker::Number.decimal(4, 2),
    hiredate: Faker::Time.between("2016-01-01", "2016-04-30")
    )
end

  p "Created #{Receptionist.count} receptionists"

20.times do
  Lifeguard.create!(
    pesel: Faker::Number.number(11),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    date_of_birth: Faker::Time.between("1970-01-01", "2000-12-31"),
    email: Faker::Internet.email,
    password: Faker::Internet.password,
    salary: Faker::Number.decimal(4, 2),
    hiredate: Faker::Time.between("2016-01-01", "2016-04-30")
    )
end
 p "Created #{Lifeguard.count} lifeguards"

20.times do
  Trainer.create!(
    pesel: Faker::Number.number(11),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    date_of_birth: Faker::Time.between("1970-01-01", "2000-12-31"),
    email: Faker::Internet.email,
    password: Faker::Internet.password,
    salary: Faker::Number.decimal(4, 2),
    hiredate: Faker::Time.between("2016-01-01", "2016-04-30")
    )
end
 p "Created #{Trainer.count} trainers"

60.times do
  WorkSchedule.create!(
    start_time: Faker::Time.forward(1).strftime("%H:%M"),
    end_time: Faker::Time.forward(1).strftime("%H:%M"),
    day_of_week: Date::DAYNAMES[Random.new.rand(0..6)],
    person_id: Faker::Number.between(52, 112)
  )
end
  p "Created #{WorkSchedule.count} work schedules"
