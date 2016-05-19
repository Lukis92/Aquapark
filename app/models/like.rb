# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  like       :boolean
#  created_at :datetime
#  updated_at :datetime
#  person_id  :integer
#  news_id    :integer
#

class Like < ActiveRecord::Base
  belongs_to :news
  belongs_to :person

  validates_uniqueness_of :person, scope: :news
end
