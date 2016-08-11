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
#  person_id   :integer          not null
#

require 'rails_helper'
require 'spec_helper'

describe Activity do
  it "has a valid factory" do
    expect(FactoryGirl.create(:activity)).to be_valid
  end
  describe 'with no nil values of attributes' do
    it 'is invalid without a name' do
      expect(build(:activity, name: nil)).to be_invalid
    end
    it 'is invalid without day_of_week' do
      expect(build(:activity, day_of_week: nil)).to be_invalid
    end
    it 'is invalid without a start_on' do
      expect(build(:activity, start_on: nil)).to be_invalid
    end
    it 'is invalid without a end_on' do
      expect(build(:activity, end_on: nil)).to be_invalid
    end
    it 'is invalid without a person_id' do
      expect(build(:activity, person_id: nil)).to be_invalid
    end
  end

  describe 'with nil values of attributes' do
    it 'is valid without description' do
      expect(build(:activity, description: nil)).to be_valid
    end

    it 'is valid without max_people' do
      expect(build(:activity, max_people: nil)).to be_valid
    end
  end
end
