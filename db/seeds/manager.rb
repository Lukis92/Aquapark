Manager.create!(
                  pesel: '11111111111',
                  first_name: 'Manager',
                  last_name: "Manager",
                  date_of_birth: '1967-01-11',
                  email: 'manager@youremail.com',
                  password: 'password',
                  salary: '6500.00',
                  hiredate: '2016-04-01'
                )

p "Created #{Manager.count} manager"
