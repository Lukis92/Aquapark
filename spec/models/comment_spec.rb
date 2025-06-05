require 'rails_helper'

describe Comment, 'associations' do
  it { is_expected.to belong_to :person }
  it { is_expected.to belong_to :news }
end

describe Comment, 'validations' do
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_length_of(:body).is_at_least(5).is_at_most(500) }
end
