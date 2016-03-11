# == Schema Information
#
# Table name: people
#
#  id            :integer          not null
#  pesel         :string           not null
#  first_name    :string           not null
#  last_name     :string           not null
#  date_of_birth :date             not null
#  email         :string           not null
#  type          :string           not null
#  salary        :decimal(5, 2)
#  hiredate      :date
#

class Client < Person

end
