# db/seeds/manager.rb
# Tworzy konto managera (idempotentne)
# Uruchom: rails runner db/seeds/manager.rb

Manager.find_or_create_by!(email: 'manager@youremail.com') do |m|
  m.pesel         = '11111111111'
  m.first_name    = 'Manager'
  m.last_name     = 'Manager'
  m.date_of_birth = '1967-01-11'
  m.password      = 'password'
  m.salary        = 6500.00
  m.hiredate      = '2016-04-01'
end

puts "Manager: #{Manager.first.email} (hasło: password)"
