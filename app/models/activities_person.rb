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
  # **ASSOCIATIONS*************************************************************#
  belongs_to :activity
  belongs_to :person
  ##############################################################################

  # **VALIDATIONS**************************************************************#
  validate :check_max_people
  validates :person_id, uniqueness: { scope: [:activity_id, :date] }
  validate :check_activities_overlapping
  validate :check_ind_trainings_overlapping
  ##############################################################################
  accepts_nested_attributes_for :person, reject_if: :all_blank

  # **METHODS******************************************************************#
private
  # checking lack of slots to join activity
  def check_max_people
    unless activity.blank?
      # binding.pry
      if activity.activities_people.where(date: date).count > 0
        if activity.activities_people.where(date: date)
                                     .count >= activity.max_people
          errors.add(:base, "Została wykorzystana masymalna ilość miejsc \
                             na ten trening.")
        end
      end
    end
  end

  # checking client activity overlapping with another activities
  def check_activities_overlapping
    activities = person.activities.where(day_of_week: BackendController.helpers
    .translate_date(date))
    overlapping_join = false
    activities.each do |a|
      person.activities_people.where(date: date).each do |pa|
        if (a.start_on...a.end_on).overlaps?(pa.activity.start_on...pa.activity
                                                                      .end_on)
          overlapping_join = true
        end
      end
    end
    if overlapping_join
      errors.add(:base, 'Jesteś zapisany/na już na inne zajęcia.')
    end
  end
  # checking client activity with individual trainings
  def check_ind_trainings_overlapping
    individual_trainings = person.individual_trainings_as_client
                                 .where(date_of_training: date)
    overlapping_join = false
    individual_trainings.each do |it|
      Activity.where(id: activity_id).each do |pa|
        if (it.start_on...it.end_on).overlaps?(pa.start_on...pa.end_on)
          overlapping_join = true
        end
      end
    end
    if overlapping_join
      errors.add(:base, 'Masz w tym czasie trening indywidualny.')
    end
  end
end
