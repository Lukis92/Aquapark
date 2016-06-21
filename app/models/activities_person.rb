# == Schema Information
#
# Table name: activities_people
#
#  activity_id :integer          not null
#  person_id   :integer          not null
#  date        :date             not null
#  id          :integer          not null, primary key
#

class ActivitiesPerson < ActiveRecord::Base
  belongs_to :person
  belongs_to :activity
  validate :check_max_people
  validates :person_id, uniqueness: { scope: [:activity_id, :date] }
  accepts_nested_attributes_for :person, reject_if: :all_blank


private
  def check_max_people
    if activity.activities_people.where('date = ?', date).count > 0
      if activity.activities_people.where('date = ?', date).count >= activity.max_people
        errors.add(:error, 'Została wykorzystana masymalna ilość miejsc na ten trening.')
      end
    end
  end
end
