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
         :recoverable, :rememberable, :trackable
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
  has_many :news
  has_many :likes, dependent: :destroy
  # has_and_belongs_to_many :activities
  has_many :activities_people
  has_many :activities, through: :activities_people
  # accepts_nested_attributes_for :assignments

  has_many :activities_as_trainer,
           class_name: 'Activity',
           foreign_key: 'trainer_id'
  ##########################

  # **VALIDATIONS*******************************************************#
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  DECIMAL_REGEX = /\A\d+(?:\.\d{0,2})?\z/
  # ONLY_LETTERS = /\A[a-zA-Z]+\z/

  before_save { self.email = email.downcase }
  validates :pesel, presence: true,
                    length: { is: 11 },
                    uniqueness: true
  # ,
  # numericality: { only_integer: true }
  validates :type, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :date_of_birth, presence: true

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }

  validates :salary, presence: false, format: { with: DECIMAL_REGEX },
                     numericality: { greater_than: 0, less_than: 9999 }
  has_attached_file :profile_image, styles: { medium: '300x300>',
                                              thumb: '100x100>' },
                                    default_url: 'http://www.mediafire.com/convkey/2d40/jkaqkubtfktr7w3zg.jpg',
                                    storage: :s3,
                                    bucket: 'aquapark-project'
  validates_attachment_content_type :profile_image,
                                    content_type: /\Aimage\/.*\Z/
  validate :profile_image_size
  # validates :salary, numericality: { greater_than: 0, less_than: 9999 }
  #########################################################################

  include PgSearch
  pg_search_scope :search, against: [:pesel, :first_name, :last_name,
                                     :date_of_birth, :email, :salary,
                                     :hiredate],
                           using: {
                             tsearch: { prefix: true }
                           }
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
  # def online?
  #   if current_sign_in_at.nil?
  #     false
  #   else
  #     current_sign_in_at + 2.hours > 5.minutes.ago
  #   end
  # end

  def person_full_name_type
    "#{first_name} #{last_name} | #{translate_type}"
  end

  def profile_image_size
    unless profile_image.blank?
      if profile_image.size > 5.megabytes
        erros.add(:profile_image, "powinno ważyć mniej niż 5MB")
      end
    end
  end

  TYPES_IN_PL = {
    'Manager' => 'Kierownik',
    'Lifeguard' => 'Ratownik',
    'Receptionist' => 'Recepcjonista',
    'Trainer' => 'Trener',
    'Client' => 'Klient'
  }.freeze
  def translate_type
    TYPES_IN_PL[type]
  end

  def self.text_search(query, querydate)
    if query.present? && querydate.blank?
      search(query)
    elsif query.present? && querydate.present?
      search(query + ' ' + querydate)
    elsif query.blank? && querydate.present?
      search(querydate)
    else
      all
    end
  end
end
