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

describe Lifeguard, 'methods' do
  subject { FactoryGirl.build(:lifeguard) }
  it { is_expected.to validate_presence_of :salary }
  it { is_expected.to validate_presence_of :hiredate }
end
