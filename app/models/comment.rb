# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#  person_id  :integer
#  news_id    :integer
#

class Comment < ActiveRecord::Base
  validates :body, presence: true, length: { minimum: 5, maximum: 500 }
  belongs_to :person
  belongs_to :news
end
