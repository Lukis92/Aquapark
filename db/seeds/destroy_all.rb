# db/seeds/destroy_all.rb
# Usuwa wszystkie dane testowe i resetuje sekwencje PK
# Uruchom: rails runner db/seeds/destroy_all.rb

puts "=== Czyszczenie bazy danych ==="

[
  Notification,
  ActivitiesPerson,
  BoughtDetail,
  IndividualTraining,
  Like,
  Comment,
  Vacation,
  WorkSchedule,
  Activity,
  TrainingCost,
  EntryType,
  News,
  Client,
  Receptionist,
  Lifeguard,
  Trainer,
  Manager
].each do |model|
  count = model.count
  model.destroy_all
  puts "  #{model.name}: usunięto #{count} rekordów"
end

puts "\nResetowanie sekwencji PK..."
%w[
  notifications
  activities_people
  bought_details
  individual_trainings
  likes
  comments
  vacations
  work_schedules
  activities
  training_costs
  entry_types
  news
  people
].each do |table|
  ActiveRecord::Base.connection.reset_pk_sequence!(table)
end

puts "\nGotowe."
