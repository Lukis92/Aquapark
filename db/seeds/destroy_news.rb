News.destroy_all
ActiveRecord::Base.connection.reset_pk_sequence!('news')

p "Destroyed #{News.count} news"
