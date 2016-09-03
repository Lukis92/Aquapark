# == Schema Information
#
# Table name: activities_people
#
#  activity_id :integer          not null
#  person_id   :integer          not null
#  date        :date             not null
#  id          :integer          not null, primary key
#

FactoryGirl.define do
  factory :activities_person do
    association :activity, factory: :activity
    association :person, factory: :client
    date { Date.today.next_week.advance(days: 1) }
  end
end
