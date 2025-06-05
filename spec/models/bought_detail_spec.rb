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

describe BoughtDetail, 'validations' do
  it { is_expected.to validate_presence_of :bought_data }
  it { is_expected.to validate_presence_of :cost }
  it { is_expected.to validate_presence_of :days }
  it { is_expected.to validate_presence_of :entry_type_id }
  it { is_expected.to validate_presence_of :person_id }
end
