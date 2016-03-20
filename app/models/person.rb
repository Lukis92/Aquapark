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

class Person < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_attached_file :profile_image, styles: { medium: "300x300>", thumb: "100x100>" },
                    default_url: "https://s3.amazonaws.com/aquapark-s9434/user_default.png",
                    storage: :s3,
                    bucket: "aquapark-pubic-s9434"
  validates_attachment_content_type :profile_image, content_type: /\Aimage\/.*\Z/
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
