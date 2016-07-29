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
#

require 'rails_helper'

describe Client do
  describe 'with no nil values of attributes' do
    it 'is invalid without a pesel' do
      expect(build(:client, pesel: nil)).to_not be_valid
    end
    it 'is invalid without a first_name' do
      expect(build(:client, first_name: nil)).to_not be_valid
    end
    it 'is invalid without a last_name' do
      expect(build(:client, last_name: nil)).to_not be_valid
    end
    it 'is invalid without a date_of_birth' do
      expect(build(:client, date_of_birth: nil)).to_not be_valid
    end
    it 'is invalid without a email' do
      expect(build(:client, email: nil)).to_not be_valid
    end
    it 'is invalid without a type' do
      expect(build(:client, type: nil)).to_not be_valid
    end
  end

  describe 'with nil values of attributes' do
    it 'is valid without salary' do
      expect(build(:client, salary: nil)).to be_valid
    end

    it 'is valid without hiredate' do
      expect(build(:client, hiredate: nil)).to be_valid
    end
  end

  describe 'uniqueness' do
    subject { FactoryGirl.build(:client) }
    it 'validates presence of email' do
      expect(subject).to validate_uniqueness_of :email
    end
    it 'validates presence of pesel' do
      expect(subject).to validate_uniqueness_of :pesel
    end
  end
end

describe Receptionist do
  describe 'with no nil values of attributes' do
    it 'is invalid without a pesel' do
      expect(build(:receptionist, pesel: nil)).to_not be_valid
    end
    it 'is invalid without a first_name' do
      expect(build(:receptionist, first_name: nil)).to_not be_valid
    end
    it 'is invalid without a last_name' do
      expect(build(:receptionist, last_name: nil)).to_not be_valid
    end
    it 'is invalid without a date_of_birth' do
      expect(build(:receptionist, date_of_birth: nil)).to_not be_valid
    end
    it 'is invalid without a email' do
      expect(build(:receptionist, email: nil)).to_not be_valid
    end
    it 'is invalid without a type' do
      expect(build(:receptionist, type: nil)).to_not be_valid
    end
    it 'is invalid without a salary' do
      expect(build(:receptionist, salary: nil)).to_not be_valid
    end
    it 'is invalid without a hiredate' do
      expect(build(:receptionist, hiredate: nil)).to_not be_valid
    end
  end

  describe 'with nil values of attributes' do
    it 'is valid without salary' do
      expect(build(:client, salary: nil)).to be_valid
    end

    it 'is valid without hiredate' do
      expect(build(:client, hiredate: nil)).to be_valid
    end
  end

  describe 'uniqueness' do
    subject { FactoryGirl.build(:receptionist) }
    it 'validates presence of email' do
      expect(subject).to validate_uniqueness_of :email
    end
    it 'validates presence of pesel' do
      expect(subject).to validate_uniqueness_of :pesel
    end
  end
end

describe Lifeguard do
  describe 'with no nil values of attributes' do
    it 'is invalid without a pesel' do
      expect(build(:lifeguard, pesel: nil)).to_not be_valid
    end
    it 'is invalid without a first_name' do
      expect(build(:lifeguard, first_name: nil)).to_not be_valid
    end
    it 'is invalid without a last_name' do
      expect(build(:lifeguard, last_name: nil)).to_not be_valid
    end
    it 'is invalid without a date_of_birth' do
      expect(build(:lifeguard, date_of_birth: nil)).to_not be_valid
    end
    it 'is invalid without a email' do
      expect(build(:lifeguard, email: nil)).to_not be_valid
    end
    it 'is invalid without a type' do
      expect(build(:lifeguard, type: nil)).to_not be_valid
    end
    it 'is invalid without a salary' do
      expect(build(:lifeguard, salary: nil)).to_not be_valid
    end
    it 'is invalid without a hiredate' do
      expect(build(:lifeguard, hiredate: nil)).to_not be_valid
    end
  end

  describe 'with nil values of attributes' do
    it 'is valid without salary' do
      expect(build(:client, salary: nil)).to be_valid
    end

    it 'is valid without hiredate' do
      expect(build(:client, hiredate: nil)).to be_valid
    end
  end

  describe 'uniqueness' do
    subject { FactoryGirl.build(:lifeguard) }
    it 'validates presence of email' do
      expect(subject).to validate_uniqueness_of :email
    end
    it 'validates presence of pesel' do
      expect(subject).to validate_uniqueness_of :pesel
    end
  end
end

describe Trainer do
  describe 'with no nil values of attributes' do
    it 'is invalid without a pesel' do
      expect(build(:trainer, pesel: nil)).to_not be_valid
    end
    it 'is invalid without a first_name' do
      expect(build(:trainer, first_name: nil)).to_not be_valid
    end
    it 'is invalid without a last_name' do
      expect(build(:trainer, last_name: nil)).to_not be_valid
    end
    it 'is invalid without a date_of_birth' do
      expect(build(:trainer, date_of_birth: nil)).to_not be_valid
    end
    it 'is invalid without a email' do
      expect(build(:trainer, email: nil)).to_not be_valid
    end
    it 'is invalid without a type' do
      expect(build(:trainer, type: nil)).to_not be_valid
    end
    it 'is invalid without a salary' do
      expect(build(:trainer, salary: nil)).to_not be_valid
    end
    it 'is invalid without a hiredate' do
      expect(build(:trainer, hiredate: nil)).to_not be_valid
    end
  end

  describe 'with nil values of attributes' do
    it 'is valid without salary' do
      expect(build(:client, salary: nil)).to be_valid
    end

    it 'is valid without hiredate' do
      expect(build(:client, hiredate: nil)).to be_valid
    end
  end

  describe 'uniqueness' do
    subject { FactoryGirl.build(:trainer) }
    it 'validates presence of email' do
      expect(subject).to validate_uniqueness_of :email
    end
    it 'validates presence of pesel' do
      expect(subject).to validate_uniqueness_of :pesel
    end
  end
end
