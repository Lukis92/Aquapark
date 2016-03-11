# == Schema Information
#
# Table name: people
#
#  id            :integer          not null
#  pesel         :string           not null
#  first_name    :string           not null
#  last_name     :string           not null
#  date_of_birth :date             not null
#  email         :string           not null
#  type          :string           not null
#  salary        :decimal(5, 2)
#  hiredate      :date
#

class Person < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
 # Include default devise modules. Others available are:
 # :confirmable, :lockable, :timeoutable and :omniauthable
 # devise :database_authenticatable, :registerable,
 #         :recoverable, :rememberable, :trackable, :validatable
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

 def fullName
   "#{first_name} #{last_name}"
 end
end
