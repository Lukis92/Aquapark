# == Schema Information
#
# Table name: vacations
#
#  id        :integer          not null, primary key
#  start_at  :date             not null
#  end_at    :date             not null
#  free      :boolean          default(FALSE), not null
#  reason    :text
#  person_id :integer
#

class Vacation < ActiveRecord::Base
#**VALIDATIONS***************************#
    validates :start_at, presence: true
    validates :end_at, presence: true
#****************************************#

#**ASSOCIATIONS**********#
belongs_to :person
#************************#
end
