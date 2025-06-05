require 'rails_helper'

describe EntryType, 'associations' do
  it { is_expected.to have_many :bought_details }
end

describe EntryType, 'validations' do
  subject { build(:entry_type) }
  it { is_expected.to validate_presence_of :kind }
  it { is_expected.to validate_presence_of :kind_details }
  it { is_expected.to validate_length_of(:kind_details).is_at_least(3) }
  it { is_expected.to validate_presence_of :price }
  it { is_expected.to validate_numericality_of(:price).is_greater_than(0).is_less_than(999) }
end

describe EntryType, 'scopes' do
  let!(:ticket) { create(:entry_type, kind: 'Bilet') }
  let!(:pass) { create(:entry_type, kind: 'Karnet') }

  it 'returns tickets' do
    expect(EntryType.tickets).to include(ticket)
    expect(EntryType.tickets).not_to include(pass)
  end

  it 'returns passes' do
    expect(EntryType.passes).to include(pass)
    expect(EntryType.passes).not_to include(ticket)
  end
end
