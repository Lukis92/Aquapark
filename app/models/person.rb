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

class Person < ApplicationRecord
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
  has_many :news, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :activities_people
  has_many :activities, through: :activities_people

  has_many :activities_as_trainer,
           class_name: 'Activity',
           foreign_key: 'person_id'
  has_many :notifications, dependent: :destroy
  ##########################

  # **VALIDATIONS*******************************************************#
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  DECIMAL_REGEX = /\A\d+(?:\.\d{0,2})?\z/
  PESEL_WEIGHTS = [1, 3, 7, 9, 1, 3, 7, 9, 1, 3].freeze

  before_validation :downcase_email
  before_validation :extract_date_of_birth_from_pesel, unless: -> { is_a?(Client) }
  validates_presence_of :first_name, :last_name, :date_of_birth, :type
  validates :pesel, presence: true,
                    format: { with: /\A\d{11}\z/, message: 'musi zawierać dokładnie 11 cyfr' },
                    uniqueness: { allow_nil: true },
                    unless: -> { is_a?(Client) }
  validate :pesel_checksum_valid, unless: -> { is_a?(Client) || pesel.blank? || !pesel.match?(/\A\d{11}\z/) }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }

  has_one_attached :profile_image do |attachable|
    attachable.variant :medium, resize_to_limit: [300, 300]
    attachable.variant :thumb,  resize_to_limit: [100, 100]
  end

  validates :profile_image,
            content_type: { in: /\Aimage\/.*\z/, message: 'musi być obrazem' },
            size: { less_than: 5.megabytes, message: 'powinno ważyć mniej niż 5MB' },
            if: -> { profile_image.attached? }
  #########################################################################

  include PgSearch
  include TextSearchable
  pg_search_scope :search, against: [:pesel, :first_name, :last_name,
                                     :date_of_birth, :email, :salary,
                                     :hiredate],
                           using: {
                             tsearch: { prefix: true }
                           }
  # **METHODS*********************#
  # Returns first and last name concatenated.
  def full_name
    "#{first_name} #{last_name}"
  end
  # Calculates the age of the person.

  def age
    Date.today.strftime('%Y').to_i - date_of_birth.strftime('%Y').to_i -
      ((Date.today.strftime('%m').to_i > date_of_birth.strftime('%m').to_i ||
      (Date.today.strftime('%m').to_i == date_of_birth.strftime('%m').to_i &&
      Date.today.strftime('%d').to_i >= date_of_birth.strftime('%d').to_i)) ? 0 : 1)
  end
  # Returns the name with translated type.

  def person_full_name_type
    "#{first_name} #{last_name} | #{translate_type}"
  end
  TYPES_IN_PL = {
    'Manager' => 'Kierownik',
    'Lifeguard' => 'Ratownik',
    'Receptionist' => 'Recepcjonista',
    'Trainer' => 'Trener',
    'Client' => 'Klient'
  }.freeze

  # Returns the Polish translation of the person type.
  def translate_type
    TYPES_IN_PL[type]
  end


  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def pesel_checksum_valid
    digits = pesel.chars.map(&:to_i)
    sum = PESEL_WEIGHTS.each_with_index.sum { |w, i| w * digits[i] }
    errors.add(:pesel, 'ma nieprawidłową sumę kontrolną') unless (10 - sum % 10) % 10 == digits[10]
  end

  def extract_date_of_birth_from_pesel
    return unless pesel.present? && pesel.match?(/\A\d{11}\z/)

    yy = pesel[0..1].to_i
    mm = pesel[2..3].to_i
    dd = pesel[4..5].to_i

    year, month = case mm
                  when  1..12 then [1900 + yy, mm]
                  when 21..32 then [2000 + yy, mm - 20]
                  when 41..52 then [2100 + yy, mm - 40]
                  when 61..72 then [2200 + yy, mm - 60]
                  when 81..92 then [1800 + yy, mm - 80]
                  else return
                  end

    self.date_of_birth = Date.new(year, month, dd) rescue nil
  end
end
