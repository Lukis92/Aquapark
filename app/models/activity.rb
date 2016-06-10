# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  name        :string(20)       not null
#  description :text
#  active      :boolean          not null
#  day_of_week :string(20)       not null
#  start_on    :time             not null
#  end_on      :time             not null
#  pool_zone   :string(1)        not null
#  max_people  :integer
#  person_id   :integer
#

class Activity < ActiveRecord::Base
  has_many :activities_people
  has_many :people, through: :activities_people
  belongs_to :person
  validates_presence_of :name, :start_on, :end_on, :day_of_week, :pool_zone
  validate :activity_exists
  include PgSearch
  pg_search_scope :search, against: [:name, :description, :active, :day_of_week,
                                     :start_on, :end_on, :pool_zone,
                                     :max_people],
                           using: {
                             tsearch: { prefix: true }
                           }
  DAYS = %w(Poniedziałek Wtorek Środa Czwartek Piątek Sobota Niedziela).freeze
  def next_n_days(amount)
    day = I18n.t(:"activerecord.attributes.activity.day_number.#{day_of_week}", day_of_week)
    (Date.today...Date.today + 7 * amount).select do |d|
      d.wday == day
    end
  end

  def self.text_search(query)
    if query.present?
      search(query)
    else
      all
    end
  end

  private

  def activity_exists
    if start_on_changed? || end_on_changed? ||
       day_of_week_changed? || pool_zone_changed?
      if (Activity.where('pool_zone = ?', pool_zone).count > 0 &&
         Activity.where('day_of_week = ?', day_of_week).count > 0) &&
         ((Activity.where('start_on <= ?', start_on).count > 0 &&
            Activity.where('end_on >= ?', end_on).count > 0) ||
         (Activity.where('start_on <= ?', start_on).count > 0 &&
          Activity.where('end_on <= ?', end_on).count > 0 &&
          Activity.where('end_on >= ?', start_on).count > 0) ||
         (Activity.where('start_on >= ?', start_on).count > 0 &&
         Activity.where('start_on <= ?', end_on).count > 0 &&
         Activity.where('end_on >= ?', end_on).count > 0))
        errors.add(:error, 'W tej strefie basenu odbywają się już zajęcia. Wybierz inne godziny.')
      end
    end
  end
end
