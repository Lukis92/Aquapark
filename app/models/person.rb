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
    self.table_name = 'people'

    # **VALIDATIONS*******************************************************#
    validates :pesel, presence: true,
                      length: { is: 11 },
                      uniqueness: true
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :date_of_birth, presence: true
    validates :email, presence: true,
                      uniqueness: { case_sensitive: false },
                      format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
    has_attached_file :profile_image, styles: { medium: '300x300>', thumb: '100x100>' },
                                      default_url: 'http://www.mediafire.com/convkey/2d40/jkaqkubtfktr7w3zg.jpg',
                                      storage: :s3,
                                      bucket: 'aquapark-project'
    validates_attachment_content_type :profile_image, content_type: /\Aimage\/.*\Z/
    #########################################################################

    # **ASSOCIATIONS**********#
    has_many :work_schedules
    has_many :bought_details
    ##########################

    # **USER_ROLES***********
    ROLES = { 0 => :guest, 1 => :client, 2 => :receptionist, 3 => :lifeguard, 4 => :trainer, 5 => :manager}.freeze

    attr_reader :role

    def initialize(role_id = 0)
      @role = ROLES.has_key?(role_id.to_i) ? ROLES[role_id.to_i] : ROLES[0]
    end

    def role?(role_name)
      role == role_name
    end
    # **METHODS*********************#
    def fullName
        "#{first_name} #{last_name}"
    end
end
