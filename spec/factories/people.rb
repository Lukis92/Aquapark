# == Schema Information
#
# Table name: people
#
#  id                         :integer          not null, primary key
#  pesel                      :string           not null
#  first_name                 :string           not null
#  last_name                  :string           not null
#  date_of_birth              :date             not null
#  email                      :string           not null
#  type                       :string           not null
#  salary                     :decimal(6, 2)
#  hiredate                   :date
#  encrypted_password         :string           default(""), not null
#  reset_password_token       :string
#  reset_password_sent_at     :datetime
#  remember_created_at        :datetime
#  sign_in_count              :integer          default(0), not null
#  current_sign_in_at         :datetime
#  last_sign_in_at            :datetime
#  current_sign_in_ip         :inet
#  last_sign_in_ip            :inet
#  profile_image_file_name    :string
#  profile_image_content_type :string
#  profile_image_file_size    :integer
#  profile_image_updated_at   :datetime
#
require 'faker'

FactoryGirl.define do
  factory :person do
    pesel { Faker::Number.number(11) }
    first_name 'Thomas'
    last_name 'Owel'
    date_of_birth { Faker::Time.between('1970-01-01', '2000-12-31') }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    type 'Person'
  end

  factory :client, parent: :person, class: 'Client' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    type 'Client'
  end

  factory :trainer, parent: :person, class: 'Trainer' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    type 'Trainer'
    salary { Faker::Number.decimal(4, 2) }
    hiredate { Faker::Time.between('2016-01-01', '2016-04-30') }
  end

  factory :receptionist, parent: :person, class: 'Receptionist' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    type 'Receptionist'
    salary { Faker::Number.decimal(4, 2) }
    hiredate { Faker::Time.between('2016-01-01', '2016-04-30') }
  end

  factory :lifeguard, parent: :person, class: 'Lifeguard' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    type 'lifeguard'
    salary { Faker::Number.decimal(4, 2) }
    hiredate { Faker::Time.between('2016-01-01', '2016-04-30') }
  end
end
