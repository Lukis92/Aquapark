class CreateBookingActivity < ActiveRecord::Migration
  def change
    create_table :booking_activities do |t|
      foreign_key :booking_activities, :activities
      foreign_key :booking_activities, :clients
    end
  end
end
