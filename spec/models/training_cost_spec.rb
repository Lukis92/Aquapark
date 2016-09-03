# == Schema Information
#
# Table name: training_costs
#
#  id       :integer          not null, primary key
#  duration :integer          not null
#  cost     :decimal(5, 2)    not null
#

require 'rails_helper'


describe TrainingCost, 'associations' do
  it { is_expected.to have_many :individual_trainings }
end

describe TrainingCost, 'column specifications' do
  it { is_expected.to have_db_column(:duration).of_type(:integer).with_options(null: false) }
  it { is_expected.to have_db_column(:cost).of_type(:decimal).with_options(null: false, precision: 5, scale: 2) }
end

describe TrainingCost, 'validations' do
  it { is_expected.to validate_presence_of :duration }
  subject { FactoryGirl.build(:training_cost) }
  it { is_expected.to validate_uniqueness_of(:duration) }

  it { is_expected.to validate_presence_of :cost }
  it { is_expected.to validate_numericality_of(:cost).is_greater_than(0).is_less_than(1000) }
end

describe TrainingCost, 'factories' do
  let(:training_cost) { build(:training_cost) }
  let(:tc2) { build(:tc2) }

  it 'returns valid training cost factory' do
    expect(training_cost.valid?).to be_truthy
  end

  it 'returns valid tc2 factory' do
    expect(tc2.valid?).to be_truthy
  end
end

describe TrainingCost, 'methods' do
  describe '#full_duration' do
    let(:training_cost) { build(:training_cost) }

    it 'returns duration and cost' do
      expect(training_cost.full_duration).to eq '140 min. - 120.00 zł'
    end
  end
end
