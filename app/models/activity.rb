# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  name        :string(20)       not null
#  description :text
#  active      :boolean          not null
#  date        :date
#  start_on    :time             not null
#  end_on      :time             not null
#  pool_zone   :string(1)        not null
#  max_people  :integer
#

class Activity < ActiveRecord::Base
  has_and_belongs_to_many :people
  belongs_to :trainer, class_name: 'Person', foreign_key: 'trainer_id'
  validates_presence_of :name, :start_on, :end_on, :pool_zone

  include PgSearch
  pg_search_scope :search, against: [:name, :description, :active, :date,
                                     :start_on, :end_on, :pool_zone,
                                     :max_people],
                           using: {
                             tsearch: { prefix: true }
                           }

  def self.text_search(query)
    if query.present?
      search(query)
    else
      all
    end
  end
end
