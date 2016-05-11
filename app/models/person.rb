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
  include PgSearch
  PgSearch.multisearch_options = { using: { tsearch: { prefix: true } } }
  multisearchable against: [:first_name, :last_name]
  PgSearch::Multisearch.rebuild(Person)
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  self.table_name = 'people'

  # **ASSOCIATIONS**********#
  has_many :work_schedules, dependent: :destroy
  has_many :bought_details, dependent: :destroy
  has_many :vacations, dependent: :destroy
  has_many :individual_trainings_as_trainer,
           class_name: 'IndividualTraining',
           foreign_key: 'trainer_id'
  has_many :individual_trainings_as_client,
           class_name: 'IndividualTraining',
           foreign_key: 'client_id'

  ##########################

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
  has_attached_file :profile_image, styles: { medium: '300x300>',
                                              thumb: '100x100>' },
                                    default_url: 'http://www.mediafire.com/convkey/2d40/jkaqkubtfktr7w3zg.jpg',
                                    storage: :s3,
                                    bucket: 'aquapark-project'
  validates_attachment_content_type :profile_image,
                                    content_type: /\Aimage\/.*\Z/
  #########################################################################

  # **METHODS*********************#
  def full_name
    "#{first_name} #{last_name}"
  end

  def age
    Date.today.strftime('%Y').to_i - date_of_birth.strftime('%Y').to_i -
      ((Date.today.strftime('%m').to_i > date_of_birth.strftime('%m').to_i ||
      (Date.today.strftime('%m').to_i == date_of_birth.strftime('%m').to_i &&
      Date.today.strftime('%d').to_i >= date_of_birth.strftime('%d').to_i)) ? 0 : 1)
  end

  def person_full_name_type
    "#{first_name} #{last_name} | #{type}"
  end
end
