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
