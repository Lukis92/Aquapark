# == Schema Information
#
# Table name: activities_people
#
#  activity_id :integer          not null
#  person_id   :integer          not null
#  date        :date             not null
#  id          :integer          not null, primary key
#

class ActivitiesPerson < ApplicationRecord
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
    day_of_week = BackendController.helpers.translate_date(date)
    enrolled = person.activities_people.where(date: date).includes(:activity).to_a
    activities_on_day = person.activities.where(day_of_week: day_of_week).to_a

    overlapping = activities_on_day.any? do |a|
      enrolled.any? { |pa| (a.start_on...a.end_on).overlaps?(pa.activity.start_on...pa.activity.end_on) }
    end
    errors.add(:base, 'Jesteś zapisany/na już na inne zajęcia.') if overlapping
  end

  # checking client activity with individual trainings
  def check_ind_trainings_overlapping
    current_activity = Activity.find_by(id: activity_id)
    return unless current_activity

    overlapping = person.individual_trainings_as_client
                        .where(date_of_training: date)
                        .any? { |it| (it.start_on...it.end_on).overlaps?(current_activity.start_on...current_activity.end_on) }
    errors.add(:base, 'Masz w tym czasie trening indywidualny.') if overlapping
  end
end
