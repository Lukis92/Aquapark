class Comment < ActiveRecord::Base
  validates :body, presence: true, length: { minimum: 5, maximum: 500 }
  belongs_to :person
  belongs_to :news
end
