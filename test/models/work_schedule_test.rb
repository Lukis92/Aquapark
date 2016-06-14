# == Schema Information
#
# Table name: work_schedules
#
#  id          :integer          not null, primary key
#  start_time  :time             not null
#  end_time    :time             not null
#  day_of_week :string           not null
#  person_id   :integer          not null
#

require 'test_helper'

class WorkScheduleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
