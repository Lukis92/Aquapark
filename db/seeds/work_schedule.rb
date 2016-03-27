NAZWY_DNI = ['Poniedziałek', 'Wtorek', 'Środa', 'Czwartek', 'Piątek', 'Sobota', 'Niedziela']
5.times do
  WorkSchedule.create!(
    start_time: Faker::Time.forward(1, :morning),
    end_time: Faker::Time.forward(1, :afternoon),
    day_of_week: NAZWY_DNI.sample,
    person_id: rand(52...112)
  )
end
  p "Created #{WorkSchedule.count} work schedules"
