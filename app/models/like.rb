# == Schema Information
#
# Table name: likes
#
#  id        :integer          not null, primary key
#  like      :boolean
#  person_id :integer          not null
#  news_id   :integer          not null
#

class Like < ActiveRecord::Base
  belongs_to :news
  belongs_to :person

  validates_uniqueness_of :person, scope: :news
end
