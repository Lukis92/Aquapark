# == Schema Information
#
# Table name: bought_details
#
#  id            :integer          not null, primary key
#  bought_data   :datetime         not null
#  start_on      :date
#  end_on        :date             not null
#  entry_type_id :integer          not null
#  person_id     :integer          not null
#  cost          :decimal(5, 2)    not null
#

require 'rails_helper'

describe BoughtDetail, 'associations' do
  it { is_expected.to belong_to :entry_type }
  it { is_expected.to belong_to :person }
end

describe BoughtDetail, 'column specifications' do
  it { is_expected.to have_db_column(:bought_data).of_type(:datetime).with_options(null: false)}
  it { is_expected.to have_db_column(:start_on).of_type(:date).with_options(null: true) }
end


describe BoughtDetail, '#active?' do
  it 'returns true when current date is within range' do
    bd = create(:bought_detail, start_on: Date.today - 1, days: 10)
    expect(bd.active?).to be_truthy
  end

  it 'returns false when current date is outside range' do
    bd = create(:bought_detail, start_on: Date.today - 10, days: 5)
    expect(bd.active?).to be_falsey
  end
end

describe BoughtDetail, '#timeline' do
  let(:person)     { create(:client) }
  let(:entry_type) { create(:entry_type) }
  let!(:existing)  { create(:bought_detail, person: person, entry_type: entry_type, start_on: Date.today, days: 10) }

  it 'is invalid when date range overlaps an existing bought detail of the same kind' do
    overlapping = build(:bought_detail, person: person, entry_type: entry_type, start_on: Date.today + 2, days: 5)
    expect(overlapping.valid?).to be_falsey
    expect(overlapping.errors[:base]).to include('Masz już aktywną wejściówkę w tym okresie.')
  end

  it 'is valid when date range does not overlap any existing bought detail' do
    non_overlapping = build(:bought_detail, person: person, entry_type: entry_type, start_on: Date.today + 15, days: 5)
    expect(non_overlapping.valid?).to be_truthy
  end

  it 'is valid for a different person with overlapping dates' do
    other_person = create(:client)
    other = build(:bought_detail, person: other_person, entry_type: entry_type, start_on: Date.today + 2, days: 5)
    expect(other.valid?).to be_truthy
  end
end
