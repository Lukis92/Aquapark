# == Schema Information
#
# Table name: entry_types
#
#  id           :integer          not null, primary key
#  kind         :string           not null
#  kind_details :string           not null
#  description  :text
#  price        :decimal(5, 2)    not null
#

require 'test_helper'

class EntryTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
