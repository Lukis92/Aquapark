# == Schema Information
#
# Table name: activities_people
#
#  activity_id :integer          not null
#  person_id   :integer          not null
#  date        :date             not null
#  id          :integer          not null, primary key
#

require 'rails_helper'

describe ActivitiesPerson, 'associations' do
  it { is_expected.to belong_to :activity }
  it { is_expected.to belong_to :person }
end

describe ActivitiesPerson, 'column specifications' do
  it { is_expected.to have_db_column(:activity_id).of_type(:integer).with_options(null: false) }
  it { is_expected.to have_db_column(:person_id).of_type(:integer).with_options(null: false) }
  it { is_expected.to have_db_column(:date).of_type(:date) }

  it { is_expected.to have_db_index [:activity_id, :person_id] }
  it { is_expected.to have_db_index [:person_id, :activity_id] }
end

describe ActivitiesPerson, 'validations' do
  let(:activities_person) { create :activities_person}
  it { expect(activities_person).to validate_uniqueness_of(:person_id).scoped_to(:activity_id, :date).case_insensitive }
end
