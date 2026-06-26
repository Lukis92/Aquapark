require 'rails_helper'

describe Vacation, 'associations' do
  it { is_expected.to belong_to :person }
end

describe Vacation, 'validations' do
  it { is_expected.to validate_presence_of :start_at }
  it { is_expected.to validate_presence_of :end_at }
  it { is_expected.to validate_presence_of :person_id }
end

describe Vacation, '#start_at_must_be_before_end_at' do
  let(:vacation) { build(:vacation, start_at: Date.today + 5, end_at: Date.today + 1) }

  it 'is invalid when start_at is after end_at' do
    expect(vacation.valid?).to be_falsey
  end
end

describe Vacation, '#validate_start_at' do
  it 'is invalid when start_at is in the past' do
    vacation = build(:vacation, start_at: Date.today - 1, end_at: Date.today + 5)
    expect(vacation.valid?).to be_falsey
    expect(vacation.errors[:base]).to include('Data od nie może być wcześniejsza niż dzisiejsza data.')
  end

  it 'is valid when start_at is today' do
    vacation = build(:vacation, start_at: Date.today, end_at: Date.today + 5)
    expect(vacation.valid?).to be_truthy
  end
end

describe Vacation, '#timeline' do
  let(:person) { create(:trainer) }
  let!(:existing) do
    create(:vacation, person: person, start_at: Date.today + 2, end_at: Date.today + 8)
  end

  it 'is invalid when vacation overlaps an existing one' do
    overlapping = build(:vacation, person: person, start_at: Date.today + 3, end_at: Date.today + 5)
    expect(overlapping.valid?).to be_falsey
    expect(overlapping.errors[:base]).to include('Masz już urlop w tym okresie.')
  end

  it 'is valid when vacation does not overlap any existing one' do
    non_overlapping = build(:vacation, person: person, start_at: Date.today + 10, end_at: Date.today + 15)
    expect(non_overlapping.valid?).to be_truthy
  end
end
