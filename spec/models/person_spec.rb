# == Schema Information
#
# Table name: people
#
#  id                         :integer          not null, primary key
#  pesel                      :string           not null
#  first_name                 :string           not null
#  last_name                  :string           not null
#  date_of_birth              :date             not null
#  email                      :string           not null
#  type                       :string           not null
#  salary                     :decimal(6, 2)
#  hiredate                   :date
#  encrypted_password         :string           default(""), not null
#  reset_password_token       :string
#  reset_password_sent_at     :datetime
#  remember_created_at        :datetime
#  sign_in_count              :integer          default(0), not null
#  current_sign_in_at         :datetime
#  last_sign_in_at            :datetime
#  current_sign_in_ip         :inet
#  last_sign_in_ip            :inet
#  profile_image_file_name    :string
#  profile_image_content_type :string
#  profile_image_file_size    :integer
#  profile_image_updated_at   :datetime
#  activity_id                :integer
#

require 'rails_helper'

describe Person do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:person)).to be_valid
  end
  it 'is invalid without a first_name' do
    expect(FactoryGirl.build(:person, first_name: nil)).to_not be_valid
  end
  it 'is invalid without a last_name' do
    expect(FactoryGirl.build(:person, last_name: nil)).to_not be_valid
  end
  it 'is invalid without a date_of_birth' do
    expect(FactoryGirl.build(:person, date_of_birth: nil)).to_not be_valid
  end
  it 'is invalid without a email' do
    expect(FactoryGirl.build(:person, email: nil)).to_not be_valid
  end
  describe 'uniqueness' do
    subject { FactoryGirl.build(:person) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of(:pesel).case_insensitive }
  end

end
