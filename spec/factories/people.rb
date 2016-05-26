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
#  activity_id                :integer
#

FactoryGirl.define do
  TYPES = %w(Manager, Lifeguard, Client, Receptionist, Trainer).freeze
  factory :person do
    pesel { Faker::Number.number(11) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    date_of_birth { Faker::Time.between('1970-01-01', '2000-12-31') }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    type { TYPES.sample }
  end

  trait :manager do
    pesel { Faker::Number.number(11) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    date_of_birth { Faker::Time.between('1970-01-01', '2000-12-31') }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    salary { Faker::Number.decimal(4, 2) }
    hiredate { Faker::Time.between('2016-01-01', '2016-04-30') }
    type { TYPES.sample }
  end
end
