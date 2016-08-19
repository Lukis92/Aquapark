# == Schema Information
#
# Table name: activities_people
#
#  activity_id :integer          not null
#  person_id   :integer          not null
#  date        :date             not null
#  id          :integer          not null, primary key
#
require 'faker'

FactoryGirl.define do
  factory :activities_person do
    association :activity, factory: :activity
    association :client, factory: :client
    date { Date.today.next_week.advance(days: 1) }
  end
end
