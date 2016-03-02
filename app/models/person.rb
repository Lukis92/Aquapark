class Person < ActiveRecord::Base
 self.abstract_class = true
 self.table_name = 'people'

 validates :pesel, presence: true,
                   length: {is: 11},
                   uniqueness: true
 validates :first_name, presence: true
 validates :last_name, presence: true
 validates :date_of_birth, presence: true
 validates :email, presence: true,
                   uniqueness: true,
                   format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}
end
