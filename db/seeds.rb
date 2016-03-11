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

Manager.create!([{
  pesel: "95232822947",
  first_name: "Prezes",
  last_name: "Łukasz",
  date_of_birth: "1967-01-11",
  email: "prezes@purespace.pl",
  password: "password"
  }])

  p "Created #{Manager.count} managers"

Client.create!([{
  pesel: "98543029375",
  first_name: "Łukasz",
  last_name: "Korol",
  date_of_birth: "1992-05-21",
  email: "lukas.korol@gmail.com",
  password: "_/f4:X-{5,P/}(JV",
  }])

  p "Created #{Client.count} clients"

Receptionist.create!([{
  pesel: "92253068447",
  first_name: "Tomasz",
  last_name: "Nowak",
  date_of_birth: "1986-08-15",
  email: "tomasz.nowak@gmail.com",
  salary: 2500.00,
  hiredate: "2016-03-21",
  password: "/GUrFr~8{@8u_7L/"
  }])

  p "Created #{Receptionist.count} receptionists"

Lifeguard.create!([{
  pesel: "99129557279",
  first_name: "Weronika",
  last_name: "Laskowska",
  date_of_birth: "1989-09-04",
  email: "weronika.laskowska@gmail.com",
  salary: 3700.00,
  hiredate: "2016-04-19",
  password: "e,qY};6XF/9'w;[4"
  }])

 p "Created #{Lifeguard.count} lifeguards"

Trainer.create!([{
  pesel: "96461803299",
  first_name: "Alicja",
  last_name: "Pocholska",
  date_of_birth: "1986-11-15",
  email: "alicja.pocholska@gmail.com",
  salary: 3100.00,
  hiredate: "2016-03-03",
  password: "pbx.mLEb+5xeg5>7"
  }])

 p "Created #{Trainer.count} trainers"
