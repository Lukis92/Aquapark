require 'rails_helper'

describe Like, 'associations' do
  it { is_expected.to belong_to :person }
  it { is_expected.to belong_to :news }
end

describe Like, 'validations' do
  let!(:like) { create(:like) }

  it 'requires unique person per news' do
    duplicate = build(:like, person: like.person, news: like.news)
    expect(duplicate.valid?).to be_falsey
  end
end
