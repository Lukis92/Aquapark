Activity.destroy_all
ActiveRecord::Base.connection.reset_pk_sequence!('activities')
p "Destroyed and reseted activities"
