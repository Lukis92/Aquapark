require 'rails_helper'

describe Client, 'validations' do
  it 'does not require pesel' do
    client = build(:client, pesel: nil)
    expect(client.valid?).to be_truthy
  end

  it 'does not validate pesel format when pesel is set' do
    client = build(:client, pesel: 'dowolny_tekst')
    expect(client.valid?).to be_truthy
  end

  it 'does not validate pesel checksum' do
    client = build(:client, pesel: '91030100001')
    expect(client.valid?).to be_truthy
  end

  it 'does not extract date_of_birth from pesel' do
    dob = Date.new(1985, 6, 15)
    client = build(:client, pesel: '91030100008', date_of_birth: dob)
    client.valid?
    expect(client.date_of_birth).to eq dob
  end
end

describe Client, 'factories' do
  let(:client) { build(:client) }

  it 'returns a valid factory' do
    expect(client.valid?).to be_truthy
  end
end
