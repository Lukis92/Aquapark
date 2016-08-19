# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text
#  active      :boolean
#  day_of_week :string           not null
#  start_on    :time             not null
#  end_on      :time             not null
#  pool_zone   :string           not null
#  max_people  :integer
#  person_id   :integer          not null
#

require 'rails_helper'
require 'spec_helper'

describe Activity, 'associations' do
  it { is_expected.to have_many :activities_people }
  it { is_expected.to have_many(:people).through(:activities_people) }
  it { is_expected.to belong_to :person }
end

describe Activity, 'column specifications' do
  it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:description).of_type(:text) }
  it { is_expected.to have_db_column(:active).of_type(:boolean) }
  it { is_expected.to have_db_column(:day_of_week).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:start_on).of_type(:time).with_options(null: false) }
  it { is_expected.to have_db_column(:end_on).of_type(:time).with_options(null: false) }
  it { is_expected.to have_db_column(:pool_zone).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:max_people).of_type(:integer) }
  it { is_expected.to have_db_column(:person_id).of_type(:integer).with_options(null: false) }

  it { is_expected.to have_db_index :person_id }
end

describe Activity, 'validations' do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :day_of_week }
  it { is_expected.to validate_presence_of :start_on }
  it { is_expected.to validate_presence_of :end_on }
  it { is_expected.to validate_presence_of :pool_zone }
  it { is_expected.to validate_presence_of :person_id }
end

describe Activity, 'methods' do
  subject { Activity }

  describe '.text_search(query)' do
    let(:activity) { create(:activity) }

    context 'when query string is nil' do
      it 'returns all activities' do
        expect(subject.text_search(nil)).to eq([activity])
      end
    end

    it 'searches for activities using given query string' do
      expect(subject.text_search('Fit Girls')).to include(activity)
    end

    it 'is case insensitive' do
      expect(subject.text_search('FIT GIRLS')).to include(activity)
    end

    it 'finds activities by day of week' do
      expect(subject.text_search('Wtorek')).to include(activity)
    end

    it 'finds activities by name and start_on combination' do
      expect(subject.text_search('Fit Girls 12:00')).to include(activity)
    end

    it 'finds activities by partial name and end_on combination' do
      expect(subject.text_search('Gir 13:00')).to include(activity)
    end
  end

  describe '#next_n_days(n=2)' do
    let(:activity) { FactoryGirl.build(:activity) }

    context 'when n is nil' do
      it 'returns 2 nearest dates for day_of_week' do
        expect(activity.send(:next_n_days).size).to eq 2
      end
    end
    it 'returns next 4 nearest dates for day_of_week' do
      expect(activity.send(:next_n_days, 4)).to be_an_instance_of(Array)
      expect(activity.send(:next_n_days, 4).size).to eq 4
    end
  end

  describe '#not_overlapping_activity' do
    let!(:activity) { create(:activity) }
    let(:first) { build(:activity1) }
    let(:second) { build(:activity2) }
    let(:third) { build(:activity3) }
    let(:fourth) { build(:activity4) }

    context 'when day_of_week, pool_zone are same and times overlap' do
      it 'raises an error that times overlap' do
        expect(first.valid?).to be_falsey
        expect(first.errors[:base].size).to eq 1
      end
    end

    context 'when day_of_week, pool_zone, are same but diff times' do
      it 'passes validation' do
        expect(second.valid?).to be_truthy
      end
    end
    context 'when day_of_week are same, times overlap but pool_zone\'s diff' do
      it 'passes validation' do
        expect(third.valid?).to be_truthy
      end
    end

    context 'when day_of_week are diff, times overlap and pool_zone\'s same' do
      it 'passes validation' do
        expect(fourth.valid?).to be_truthy
      end
    end
  end

  describe '#not_overlapping_trainer_work' do
    let(:individual_training) { build(:individual_training) }
    let(:activity) { create(:activity) }
    let(:first) { build(:first, person_id: activity[:person_id], pool_zone: 'C') }
    context 'when trainer has another activity on same time' do
      it 'raises an error' do
        expect(activity.valid?).to be_truthy
        expect(first.valid?).to be_falsey
      end
    end

    context 'when trainer has individual training on same time' do
      it 'raises an error' do
        expect(individual_training.valid?).to be_truthy
        expect(first.valid?).to be_falsey
      end
    end
  end

  describe '#start_on_must_be_before_end_on' do
    let(:activity) { build(:activity, end_on: '11:00') }
    let(:activity2) { build(:activity, end_on: '12:20') }
    context 'when start_on is after end_on' do
      it 'raises an error' do
        expect(activity.valid?).to be_falsey
      end
    end

    context 'when activity lasts less than 30 minutes' do
      it 'raises an error' do
        expect(activity2.valid?).to be_falsey
      end
    end
  end

  describe '#overlapping_trainer_work_schedule' do
    let(:work_schedule) { create(:work_schedule) }
    let(:activity) { build(:activity, person_id: work_schedule[:person_id]) }
    context 'when trainer doesn\'t work when will be activity' do
      it 'raises an error' do
        expect(work_schedule.valid?).to be_truthy
        expect(activity.valid?).to be_falsey
      end
    end
  end
end
