NAZWY_DNI = %w(Poniedziałek Wtorek Środa Czwartek Piątek
               Sobota Niedziela).freeze
500.times do
  WorkSchedule.create!(
    start_time: Faker::Time.forward(1, :morning),
    end_time: Faker::Time.forward(1, :afternoon),
    day_of_week: NAZWY_DNI.sample,
    person_id: rand(53..115)
  )
end
p "Created #{WorkSchedule.count} work schedules"
