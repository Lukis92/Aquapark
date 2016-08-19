# == Schema Information
#
# Table name: work_schedules
#
#  id          :integer          not null, primary key
#  start_time  :time             not null
#  end_time    :time             not null
#  day_of_week :string           not null
#  person_id   :integer          not null
#

require 'rails_helper'

describe WorkSchedule, 'associations' do
  it { is_expected.to belong_to :person }
end

describe WorkSchedule, 'column specifications' do
  it { is_expected.to have_db_column(:start_time).of_type(:time).with_options(null: false) }
  it { is_expected.to have_db_column(:end_time).of_type(:time).with_options(null: false) }
  it { is_expected.to have_db_column(:day_of_week).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:person_id).of_type(:integer).with_options(null: false) }
end

describe WorkSchedule, 'validations' do
  it { is_expected.to validate_presence_of :start_time }
  it { is_expected.to validate_presence_of :end_time }
  it { is_expected.to validate_presence_of :day_of_week }
  it { is_expected.to validate_presence_of :person_id }

  subject { FactoryGirl.build(:work_schedule) }
  it { is_expected.to validate_uniqueness_of(:day_of_week).scoped_to(:person_id) }
end

describe WorkSchedule, 'methods' do
  describe '#start_must_be_before_end_time' do
    let(:work_schedule) { build(:work_schedule, start_time: '12:00', end_time: '08:00') }
    it 'raises an error' do
      expect(work_schedule.valid?).to be_falsey
    end
  end

  describe '#work_duration' do
    let(:work_schedule) { build(:work_schedule, start_time: '08:00', end_time: '08:30') }
    it 'raises an error' do
      expect(work_schedule.valid?).to be_falsey
    end
  end

  describe '#next_n_days(amount, day_of_week)' do
    let(:work_schedule) { build(:work_schedule) }
    it 'returns next 4 nearest dates for Friday' do
      expect(work_schedule.next_n_days(4, 'Piątek')).to be_an_instance_of(Array)
      expect(work_schedule.next_n_days(4, 'Piątek').size).to eq 4
    end
  end

  describe '.text_search(query)' do
    subject { WorkSchedule }
    let(:work_schedule) { create(:work_schedule) }

    context 'when query string is nil' do
      it 'returns all work_schedules' do
        expect(subject.text_search(nil)).to eq([work_schedule])
      end
    end

    it 'searches for work schedules using given query string' do
      expect(subject.text_search('Wtorek')).to include(work_schedule)
    end

    it 'is case insensitive' do
      expect(subject.text_search('WtOrEk')).to include(work_schedule)
    end

    it 'finds activities by start_time' do
      expect(subject.text_search('08:00')).to include(work_schedule)
    end
    it 'finds activities by end_time' do
      expect(subject.text_search('12:00')).to include(work_schedule)
    end
  end
end
