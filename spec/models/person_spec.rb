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

describe Person, 'associations' do
  it { is_expected.to have_many :work_schedules }
  it { is_expected.to have_many :bought_details }
  it { is_expected.to have_many :vacations }
  it { is_expected.to have_many :individual_trainings_as_trainer }
  it { is_expected.to have_many :individual_trainings_as_client }
  it { is_expected.to have_many :news }
  it { is_expected.to have_many :comments }
  it { is_expected.to have_many :likes }
  it { is_expected.to have_many :activities_people }
  it { is_expected.to have_many(:activities).through(:activities_people) }
  it { is_expected.to have_many :activities_as_trainer }
end

describe Person, 'column specifications' do
  it { is_expected.to have_db_column(:pesel).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:first_name).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:last_name).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:type).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:salary).of_type(:decimal).with_options(null: true, precision: 6, scale: 2) }
  it { is_expected.to have_db_column(:hiredate).of_type(:date).with_options(null: true) }

  it { is_expected.to have_db_index :email }
  it { is_expected.to have_db_index :reset_password_token }
end

describe Person, 'validations' do
  it { is_expected.to validate_presence_of :pesel }
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :date_of_birth }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :type }

  subject { FactoryGirl.build(:person) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_uniqueness_of(:pesel).case_insensitive }
end

describe Person, 'methods' do
  subject { Person }

  describe '#full_name' do
    let(:person) { build(:person) }

    it 'returns a full name of person' do
      expect(person.full_name).to eq 'Thomas Owel'
    end
  end

  describe '#age' do
    let(:person) { build(:person, date_of_birth: '1992-01-22')}

    it 'returns an age of person' do
      expect(person.age).to eq 24
    end
  end

  describe '#person_full_name_type' do
    let(:person) { build(:person, type: 'Manager') }

    it 'returns a full name and type of person' do
      expect(person.person_full_name_type).to eq 'Thomas Owel | Kierownik'
    end
  end

  describe '.text_search(query)' do
    let!(:person) { create(:person) }

    context 'when query string is nil' do
      it 'returns all people' do
        expect(subject.text_search(nil)).to eq([person])
      end
    end

    it 'searches for people using given query string' do
      expect(subject.text_search('Thomas Owel')).to include(person)
    end

    it 'is case insensitive' do
      expect(subject.text_search('THOMAS OWEL')).to include(person)
    end
  end

  describe '#downcase_email' do
    let(:person) { build(:person, email: 'PERSON@person.pl') }

    it 'converts letters to lowercase' do
      expect(person.send(:downcase_email)).to eq 'person@person.pl'
    end
  end
end
