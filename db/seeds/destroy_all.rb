Client.destroy_all
Receptionist.destroy_all
Lifeguard.destroy_all
Trainer.destroy_all
Manager.destroy_all
WorkSchedule.destroy_all
ActiveRecord::Base.connection.reset_pk_sequence!('people')
ActiveRecord::Base.connection.reset_pk_sequence!('work_schedules')
