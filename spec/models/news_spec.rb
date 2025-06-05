require 'rails_helper'

describe News, 'associations' do
  it { is_expected.to belong_to :person }
  it { is_expected.to have_many :likes }
  it { is_expected.to have_many :comments }
end

describe News, 'validations' do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :content }
  it { is_expected.to validate_presence_of :scope }
end

describe News, 'methods' do
  let(:news) { create(:news) }
  before do
    create(:like, news: news, like: true)
    create(:like, news: news, like: false)
  end

  it 'counts thumbs up' do
    expect(news.thumbs_up_total).to eq 1
  end

  it 'counts thumbs down' do
    expect(news.thumbs_down_total).to eq 1
  end
end
